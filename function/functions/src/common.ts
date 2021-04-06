import  * as admin from 'firebase-admin';
import DocumentSnapshot = admin.firestore.DocumentSnapshot;
import FieldValue = admin.firestore.FieldValue;


export  const pantryCollectionpath = 'userinformation/{userID}/pantrycollection'


export const getPantryPath = (ref: string, type:string) => {
    return ref.split(type)[0]
}

export const updatePantryCount = async (pantrySnapshot:DocumentSnapshot, field: string, number:number)=>{
    if(pantrySnapshot.exists)
        return pantrySnapshot.ref.update({
            [field]: FieldValue.increment(number)
        }).then((value => {
            console.log("pantry count updated")
        })).catch(reason => {
            console.log(reason)
        })
}