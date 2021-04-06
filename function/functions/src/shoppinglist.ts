import * as functions from 'firebase-functions';
import  * as admin from 'firebase-admin';
import * as  common from './common'

const database = admin.firestore()

const shoppingListPath = 'shoppinglist'
const shoppingListWildCard = `${common.pantryCollectionpath}/{pantryName}/shoppinglist/{shoppingID}`

export const  onAddShoppingList = functions.firestore.document(shoppingListWildCard)
    .onCreate(async (snapshot, context)=>{
        const path = snapshot.ref.path

        const pantrySnapshot = await database.doc(common.getPantryPath(path,shoppingListPath)).get()
        const field = "numberOfShoppingList"
        return common.updatePantryCount(pantrySnapshot,field,1)
    })

export const  onDeleteShoppingList = functions.firestore.document(shoppingListWildCard)
    .onDelete(async (snapshot, context)=>{
        const path = snapshot.ref.path

        const pantrySnapshot = await database.doc(common.getPantryPath(path,shoppingListPath)).get()
        const field = "numberOfShoppingList"
        return common.updatePantryCount(pantrySnapshot,field,-1)
    })


