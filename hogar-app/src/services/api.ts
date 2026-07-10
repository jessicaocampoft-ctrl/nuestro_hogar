import { supabase } from './supabase';
import { CoupleNote, Expense, HouseholdTask } from '../types';
export const api={
 async expenses(groupId:string){const {data,error}=await supabase.from('expenses').select('*, expense_splits(*)').eq('group_id',groupId).order('expense_date',{ascending:false});if(error)throw error;return data as Expense[];},
 async addExpense(expense:Omit<Expense,'id'|'expense_splits'>,splits:Expense['expense_splits']){const {data,error}=await supabase.from('expenses').insert(expense).select().single();if(error)throw error;const {error:se}=await supabase.from('expense_splits').insert(splits.map(s=>({...s,expense_id:data.id})));if(se)throw se;return data;},
 async tasks(groupId:string){const {data,error}=await supabase.from('household_tasks').select('*').eq('group_id',groupId).order('task_date');if(error)throw error;return data as HouseholdTask[];},
 async notes(groupId:string){const {data,error}=await supabase.from('couple_notes').select('*').eq('group_id',groupId).neq('status','deleted').order('created_at',{ascending:false});if(error)throw error;return data as CoupleNote[];}
};
