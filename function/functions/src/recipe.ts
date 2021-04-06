import * as functions from 'firebase-functions';
import  * as admin from 'firebase-admin';
import * as  common from './common'


const database = admin.firestore()

const recipePath = 'recipes'
const recipeWildCard = `${common.pantryCollectionpath}/{pantryName}/recipes/{recipeID}`

export const  onAddRecipe = functions.firestore.document(recipeWildCard)
    .onCreate(async (snapshot, context)=>{
        const path = snapshot.ref.path

        const pantrySnapshot = await database.doc(common.getPantryPath(path,recipePath)).get()
        const field = "numberOfRecipes"
        return common.updatePantryCount(pantrySnapshot,field,1)
    })

export const  onDeleteRecipe = functions.firestore.document(recipeWildCard)
    .onDelete(async (snapshot, context)=>{
        const path = snapshot.ref.path

        const pantrySnapshot = await database.doc(common.getPantryPath(path,recipePath)).get()
        const field = "numberOfRecipes"
        return  common.updatePantryCount(pantrySnapshot,field,-1)
    })

