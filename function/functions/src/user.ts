import * as functions from 'firebase-functions';
import {addPantryFunc} from './pantry';
import * as admin from "firebase-admin";
// @ts-ignore
import  * as firebase_tools from 'firebase-tools';

const database = admin.firestore()

export const  onAddUser = functions.firestore.document('userinformation/{userID}')
    .onCreate(async (snapshot, context)=>{

        await addPantryFunc(snapshot.ref,"Default Pantry");

    })


export const editUsername = functions.https.onCall(async (data, context) => {
    const userID = data.userID
    const oldUsername = data.oldUsername
    const newUsername = data.newUsername
    const userPath = `userinformation/${userID}`

    await database.doc(userPath).get().then(async snapshot => {
        const userDocument = snapshot.data()
        const pantriesReference = userDocument?.pantriesReference
        // @ts-ignore
        for (const [key, value] of Object.entries(pantriesReference)) {
            // @ts-ignore
            await database.doc(value).get().then(async pantryDoc => {
                const membersUpdate = pantryDoc.data()?.members;
                const val = membersUpdate[oldUsername];
                delete membersUpdate[oldUsername]
                membersUpdate[newUsername] = val;
                await pantryDoc.ref.update({
                    members: membersUpdate
                    // tslint:disable-next-line:no-shadowed-variable
                }).then( value => {
                    return {status: 'OK', code: 200, message: 'username updated successfully'}
                }).catch(reason => {
                    return {status: 'Error', code: 400, message: 'Bad request'}
                });
            })
        }

    }).catch(reason => {
        console.log(reason)
    })



})

export const deleteUser = functions.runWith({
        timeoutSeconds: 540,
        memory: '2GB'
    }).https.onCall(async (data, context) => {

        const userID = data.userID
        const userPath = `userinformation/${userID}`
        const user = await database.doc(userPath).get()
        const email = user.data()?.email

        await firebase_tools.firestore
            .delete(userPath, {
                project: process.env.GCLOUD_PROJECT,
                recursive: true,
                yes: true,
                // token: functions.config().fb.token
            });

        const options = {
            prefix: `${email}/`,
        };
        const [files] = await admin.storage().bucket().getFiles(options);
        for (const file of files) {
            await file.delete();
        }
        return {
            path: userPath
        };
    }
    );
