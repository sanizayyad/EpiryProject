import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
// @ts-ignore
import  * as firebase_tools from 'firebase-tools';
import Timestamp = admin.firestore.Timestamp;
import DocumentReference = admin.firestore.DocumentReference;

const database = admin.firestore()

export const newPantryModel = (pantryName: string, path:string, member:string) => {
    return {
        pantryName,
        members: {
            [member]: pantryName === "Default Pantry" ? "Default" : "Created"
        },
        dateCreated: Timestamp.now().toDate().toDateString(),
        numberOfCategories: 0,
        numberOfProducts: 0,
        numberOfShoppingList: 0,
        numberOfRecipes: 0,
        deepLinkExpiration: {},
        path
    };
}

export const addPantryFunc = async (userReference: DocumentReference, pantryName: string) => {

    const pantryPath = `userinformation/${userReference.id}/pantrycollection/${pantryName}`
    const user = await userReference.get()
    await database.doc(pantryPath).set(newPantryModel(pantryName,pantryPath, user.data()?.username))

    await userReference.get().then(async snapshot => {
        const pantryRef = snapshot.data()?.pantriesReference ?? {}
        pantryRef[pantryName] = pantryPath
        await snapshot.ref.update({pantriesReference: pantryRef});
    })

    const categoryPath = `${pantryPath}/categories/`
    await database.collection(categoryPath).add({categoryName: 'uncategorized'})
    return
}


export const createPantry = functions.https.onCall(async (data, context) => {
    const userID = data.userID
    const userReference = database.doc(`userinformation/${userID}`);
    const pantryName = data.pantryName

    await addPantryFunc(userReference,pantryName)
        .then(value => {
            return {status: 'OK', code: 200, message: 'Pantry Created successfully'}
        })
        .catch(reason => {
            return {status: 'Error', code: 400, message: 'Bad request'}
        });
})


export const deletePantry = functions.runWith({
    timeoutSeconds: 540,
    memory: '2GB'
}).https.onCall(async (data, context) => {

    const path = data.path
    const pantryName = data.pantryName

    await firebase_tools.firestore
        .delete(path, {
            project: process.env.GCLOUD_PROJECT,
            recursive: true,
            yes: true,
            // token: functions.config().fb.token
        })
    await database.doc(path.split('pantrycollection')[0]).get().then(async snapshot => {
        const pantryRef = snapshot.data()?.pantriesReference
        delete pantryRef[pantryName]
        await snapshot.ref.update({pantriesReference:pantryRef});
    })
    return {
        path: path
    };
});


