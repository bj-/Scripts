/*     занимаемое дисковое пространство таблицами в БД (размеры в килобайтах)    */
/*     + общее занимаемое место базой    */

-- обновим статистику и получим обобщенную инфу
exec sp_spaceused null, 'true'
--
create table #data 
(
    name        sysname,
    rows        bigint,
    reserved    varchar(500),
    data        varchar(500),
    index_size    varchar(500),
    unused        varchar(500)
)

create table #result
(
    name        sysname,
    rows        bigint,
    reserved    bigint, --numeric(28, 2),
    data        bigint, --numeric(28, 2),
    index_size    bigint, --numeric(28, 2),
    unused        bigint, --numeric(28, 2),
)

declare @name sysname
declare sel cursor local fast_forward for
    select name from sysobjects where xtype = 'U'
open sel
fetch next from sel into @name
while @@fetch_status = 0
begin
    set @name = 'dbo.[' + @name + ']'
    insert into #data 
    exec sp_spaceused @name
    fetch next from sel into @name
end

insert into #result
select name,rows, left(reserved, len(reserved) - 3),
left(data, len(data) - 3),
left(index_size, len(index_size) - 3),
left(unused, len(unused) - 3)  from #data -- order by rows desc

select name, rows, reserved, data, index_size, unused
from #result order by reserved desc, data desc, rows desc

drop table #data
drop table #result
