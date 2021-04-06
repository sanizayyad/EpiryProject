import * as functions from 'firebase-functions';
import  * as admin from 'firebase-admin';
import * as  common from './common'


const database = admin.firestore()

const productPath = 'products'
const productWildCard = `${common.pantryCollectionpath}/{pantryName}/products/{productID}`

export const  onAddProduct = functions.firestore.document(productWildCard)
    .onCreate(async (snapshot, context)=>{
        const path = snapshot.ref.path

        const pantrySnapshot = await database.doc(common.getPantryPath(path,productPath)).get()
        const field = "numberOfProducts"
        return common.updatePantryCount(pantrySnapshot,field,1)
    })

export const  onDeleteProduct = functions.firestore.document(productWildCard)
    .onDelete(async (snapshot, context)=>{
        const path = snapshot.ref.path

        const pantrySnapshot = await database.doc(common.getPantryPath(path,productPath)).get()
        const field = "numberOfProducts"
        return  common.updatePantryCount(pantrySnapshot,field,-1)
    })

