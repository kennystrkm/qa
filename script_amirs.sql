/* Скрипт, который дозапрашивает у Вашего СГД не до конца поступившие сообщения*/
set term ^;
execute block
as
  declare variable p_Oid integer;
begin
  delete from "SegmentEj";

  for select p.oid from "PublishEjXpo" p
  join "DocumentFileEj" dfe on dfe."MessageId" = p."MessageId" and dfe."Blob" is null and dfe."DocumentFile" is null and dfe."FileId" is not null
  join "ImportEjXpoDoc" i on i.oid = dfe."DocumentEj" and i."Num" in (
  /* перечисляем сообщения поступившие в АМИРС, но недоступные для импорта в ЖВК */
  '31MS0003-202-24-0000568', /*в столбик обрамляем каждый идентификатор одинарными кавычками*/
  '31MS0003-202-24-0000552' /* последнее сообщение без запятой*/
  )
  into :p_Oid
  do
  begin
    update "PublishEjXpo" p set p."Status" = 0, p."Sent" = 0 where p.oid = :p_Oid;
  end 
end;
^
