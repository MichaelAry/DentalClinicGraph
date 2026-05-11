EXEC master.dbo.xp_instance_regread
     N'HKEY_LOCAL_MACHINE',
     N'Software\Microsoft\MSSQLServer\MSSQLServer',
     N'BackupDirectory';

BACKUP DATABASE DentalClinicGraph
    TO DISK = N'/var/opt/mssql/data/DentalClinicGraph.bak'
    WITH INIT;

docker cp sql-server-windows:/var/opt/mssql/data/DentalClinicGraph.bak C:\Users\michael\Documents\DentalClinicGraph\DentalClinicGraph.bak