import { CoupleNote, Expense, HouseholdTask, Member } from '../types';
export const demoMembers:Member[]=[{user_id:'jessica',name:'Jessica',email:'jessica@hogar.app'},{user_id:'mateo',name:'Mateo',email:'mateo@hogar.app'}];
export const demoExpenses:Expense[]=[
 {id:'e1',group_id:'demo',paid_by:'jessica',payer_name:'Jessica',amount:120000,category:'Restaurantes',description:'Salida a cenar',expense_date:'2026-07-05',split_type:'equal',expense_splits:[{user_id:'jessica',user_name:'Jessica',amount_owed:60000},{user_id:'mateo',user_name:'Mateo',amount_owed:60000}]},
 {id:'e2',group_id:'demo',paid_by:'mateo',payer_name:'Mateo',amount:300000,category:'Mercado',description:'Mercado',expense_date:'2026-07-06',split_type:'equal',expense_splits:[{user_id:'jessica',user_name:'Jessica',amount_owed:150000},{user_id:'mateo',user_name:'Mateo',amount_owed:150000}]},
 {id:'e3',group_id:'demo',paid_by:'jessica',payer_name:'Jessica',amount:60000,category:'Transporte',description:'Transporte',expense_date:'2026-07-07',split_type:'equal',expense_splits:[{user_id:'jessica',user_name:'Jessica',amount_owed:30000},{user_id:'mateo',user_name:'Mateo',amount_owed:30000}]},
 {id:'e4',group_id:'demo',paid_by:'jessica',payer_name:'Jessica',amount:80000,category:'Regalos',description:'Regalo personal',expense_date:'2026-07-08',split_type:'individual',expense_splits:[{user_id:'jessica',user_name:'Jessica',amount_owed:80000},{user_id:'mateo',user_name:'Mateo',amount_owed:0}]}
];
export const demoTasks:HouseholdTask[]=[
 {id:'t1',group_id:'demo',title:'Lavar platos',task_date:'2026-07-05',frequency:'once',assigned_to:'mateo',assigned_name:'Mateo',completed_by:'jessica',completed_name:'Jessica',status:'completed',completed_at:'2026-07-05T20:00:00Z'},
 {id:'t2',group_id:'demo',title:'Sacar basura',task_date:'2026-07-06',frequency:'weekly',assigned_to:'mateo',assigned_name:'Mateo',completed_by:'mateo',completed_name:'Mateo',status:'completed',completed_at:'2026-07-06T19:00:00Z'},
 {id:'t3',group_id:'demo',title:'Limpiar cocina',task_date:'2026-07-07',frequency:'weekly',assigned_to:'jessica',assigned_name:'Jessica',status:'pending'},
 {id:'t4',group_id:'demo',title:'Hacer mercado',task_date:'2026-07-08',frequency:'weekly',assigned_to:'both',assigned_name:'Ambos',completed_by:'both',completed_name:'Ambos',status:'completed',completed_at:'2026-07-08T15:00:00Z'}
];
export const demoNotes:CoupleNote[]=[
 {id:'n4',group_id:'demo',author_id:'mateo',author_name:'Mateo',recipient_id:'jessica',recipient_name:'Jessica',message:'Hoy cocino yo.',category:'Recordatorio',status:'visible',is_favorite:false,is_read:false,created_at:'2026-07-08T10:00:00Z'},
 {id:'n3',group_id:'demo',author_id:'jessica',author_name:'Jessica',recipient_id:'mateo',recipient_name:'Mateo',message:'Estoy orgullosa de ti.',category:'Motivación',status:'visible',is_favorite:true,is_read:true,read_at:'2026-07-07T18:00:00Z',created_at:'2026-07-07T09:00:00Z'},
 {id:'n2',group_id:'demo',author_id:'mateo',author_name:'Mateo',recipient_id:'jessica',recipient_name:'Jessica',message:'Gracias por ayudarme con la casa.',category:'Agradecimiento',status:'visible',is_favorite:false,is_read:true,created_at:'2026-07-06T09:00:00Z'},
 {id:'n1',group_id:'demo',author_id:'jessica',author_name:'Jessica',recipient_id:'mateo',recipient_name:'Mateo',message:'Ten lindo día, te amo.',category:'Amor',status:'visible',is_favorite:false,is_read:true,created_at:'2026-07-05T09:00:00Z'}
];
