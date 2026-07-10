-- Crea antes jessica@hogar.app y mateo@hogar.app en Authentication.
do $$ declare j uuid; m uuid; g uuid; e uuid; begin
 select id into j from auth.users where email='jessica@hogar.app';
 select id into m from auth.users where email='mateo@hogar.app';
 if j is null or m is null then raise exception 'Primero crea ambos usuarios en Authentication'; end if;
 insert into groups(name,invite_code,created_by) values('Jessica & Mateo','HOGAR2',j) returning id into g;
 insert into group_members(group_id,user_id,role) values(g,j,'owner'),(g,m,'member');
 insert into expenses(group_id,paid_by,amount,category,description,expense_date,split_type,created_by) values(g,j,120000,'Restaurantes','Salida a cenar','2026-07-05','equal',j) returning id into e;
 insert into expense_splits(expense_id,user_id,amount_owed,percentage) values(e,j,60000,50),(e,m,60000,50);
 insert into expenses(group_id,paid_by,amount,category,description,expense_date,split_type,created_by) values(g,m,300000,'Mercado','Mercado','2026-07-06','equal',m) returning id into e;
 insert into expense_splits(expense_id,user_id,amount_owed,percentage) values(e,j,150000,50),(e,m,150000,50);
 insert into expenses(group_id,paid_by,amount,category,description,expense_date,split_type,created_by) values(g,j,60000,'Transporte','Transporte','2026-07-07','equal',j) returning id into e;
 insert into expense_splits(expense_id,user_id,amount_owed,percentage) values(e,j,30000,50),(e,m,30000,50);
 insert into expenses(group_id,paid_by,amount,category,description,expense_date,split_type,created_by) values(g,j,80000,'Regalos','Regalo personal','2026-07-08','individual',j) returning id into e;
 insert into expense_splits(expense_id,user_id,amount_owed,percentage) values(e,j,80000,100),(e,m,0,0);
 insert into household_tasks(group_id,title,task_date,frequency,assigned_to,completed_by,status,completed_at,created_by) values
 (g,'Lavar platos','2026-07-05','once',m::text,j::text,'completed','2026-07-05 20:00Z',j),(g,'Sacar basura','2026-07-06','weekly',m::text,m::text,'completed','2026-07-06 19:00Z',m),(g,'Limpiar cocina','2026-07-07','weekly',j::text,null,'pending',null,j),(g,'Hacer mercado','2026-07-08','weekly','both','both','completed','2026-07-08 15:00Z',j);
 insert into couple_notes(group_id,author_id,recipient_id,message,category,is_read,is_favorite,created_at) values
 (g,j,m::text,'Ten lindo día, te amo.','Amor',true,false,'2026-07-05 09:00Z'),(g,m,j::text,'Gracias por ayudarme con la casa.','Agradecimiento',true,false,'2026-07-06 09:00Z'),(g,j,m::text,'Estoy orgullosa de ti.','Motivación',true,true,'2026-07-07 09:00Z'),(g,m,j::text,'Hoy cocino yo.','Recordatorio',false,false,'2026-07-08 10:00Z');
end $$;
