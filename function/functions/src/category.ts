import * as functions from 'firebase-functions';
import  * as admin from 'firebase-admin';
import * as  common from './common'

const database = admin.firestore()

const categoryPath = 'categories'
const categoryWildCard = `${common.pantryCollectionpath}/{pantryName}/categories/{categoryNameID}`


export const  onAddCategory = functions.firestore.document(categoryWildCard)
    .onCreate(async (snapshot, context)=>{
        const path = snapshot.ref.path

        await snapshot.ref.update({
            path: snapshot.ref.path
        })

        const pantrySnapshot = await database.doc(common.getPantryPath(path,categoryPath)).get()
        const field = "numberOfCategories"
        return common.updatePantryCount(pantrySnapshot,field,1)
    })

export const  onDeleteCategory = functions.firestore.document(categoryWildCard)
    .onDelete(async (snapshot, context)=>{
        const path = snapshot.ref.path

        const pantrySnapshot = await database.doc(common.getPantryPath(path,categoryPath)).get()
        const field = "numberOfCategories"
        return common.updatePantryCount(pantrySnapshot,field,-1)
    })


export const updateCategory = functions.https.onCall(async (data, context) => {
    const path = data.path
    const doc = await database.doc(path).get()

    const oldCategoryName = doc.data()?.categoryName
    const newCategoryName =  data.newName
    const productsPath = `${common.getPantryPath(path,categoryPath)}products`

    await doc.ref.update({
        categoryName: newCategoryName
    }).then(async value => {
        await database.collection(productsPath).get()
            .then((snapshots=>{
                // tslint:disable-next-line:no-shadowed-variable
                snapshots.docs.forEach((doc)=>{
                    const prod = doc.data()
                    if(prod.category === oldCategoryName)
                        doc.ref.update(
                            {
                                category : newCategoryName
                            }
                        ).then(value1 => {
                            console.log(`products with ${oldCategoryName} updated to ${newCategoryName}`)
                        }).catch(reason => {
                            console.log(reason)
                        })
                })
            }))
        return {status: 'OK', code: 200, message: 'Category updated successfully'}
    }).catch(reason => {
        console.log(reason)
        return {status: 'Error', code: 400, message: 'bad request'}
    })
})

export const deleteCategory = functions.https.onCall(async (data, context) => {
    const path = data.path
    const doc = await database.doc(path).get()

    const categoryName = doc.data()?.categoryName
    const productsPath = `${common.getPantryPath(path,categoryPath)}products`

    await doc.ref.delete().then(async value => {
        await database.collection(productsPath).get()
            .then((snapshots=>{
                // tslint:disable-next-line:no-shadowed-variable
                snapshots.docs.forEach((doc)=>{
                    const prod = doc.data()
                    if(prod.category === categoryName)
                        doc.ref.delete()
                            .then(value1 => {
                            console.log(`category deleted with all its products`)
                        }).catch(reason => {
                            console.log(reason)
                        })
                })
            }))
        return {status: 'OK', code: 200, message: 'Category deleted successfully'}
    }).catch(reason => {
        return {status: 'err', code: 400, message: 'Bad Request'}
    })
})
