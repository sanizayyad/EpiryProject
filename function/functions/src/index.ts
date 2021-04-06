import  * as admin from 'firebase-admin';

admin.initializeApp()

//organize functions based on importance
export * from './user'
export * from './pantry'
export * from './category'
export * from './product'
export * from './recipe'
export * from './shoppinglist'
