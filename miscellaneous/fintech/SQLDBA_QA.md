# Database Administration



[TOC]

### Installation & Configuration

**What is Database Engine?**

- The Database Engine is the primary component of SQL Server. It is the Online Transaction Processing (OLTP) engine of SQL Server.
- The Database Engine is highly optimized for transaction processing, but offers exceptional performance in complex data retrieval operations.
- Database Engine is also responsible for the controlled access and modification of data through its security subsystem.
- SQL Server supports up to 50 instances of the Database Engine on a single computer.

**What are the Network Protocols that SQL Server support?**

SQL Server support the following network protocols.

- TCP/IP.
- Named Pipes.
- Shared memory.
- VIA

**What permissions are required for a user install SQL Server on a server?**

- User must have local administrator permission required to install SQL Server on the windows server.

**What is SQL Server Instance?**

- Separate copy of same software product is called an instance.
- Each instance manage its own system databases and one or more user databases.
- Each computer can run maximum 50 standalone instances of the Database Engine. One instance can be the default instance.
- There are 2 types of instance available in SQL Server.

1. Default instance.
2. Named instance.

Default Instance:

- The default instance has no name. It’s name is equal to system Name.
- Only **ONE** default instance can installed per machine.
- The default services name is **MSSQLSERVER**.

Named Instance:

- A Named instance is one where you specify an instance name where installing the instance.
- The Named instance name is equal to SystemName\InstanceName.
- We can installed 49 names instances per machine.

**Can we install multiple instance on the same Disk?**

YES

We can install multiple instances on the same disk because each installation create it’s own folders.

**What is the default port number in SQL Server Instance?**

1433.

**What is SQL Server Browser Services Port number.**

1434.

**Can we change the default port number of SQL Server?**

Yes, We can change the default port number of SQL Server.

**How to get the SQL Server port numbers?**

Below are the methods which we can use to get the port information.

- SQL Server configuration Manager.
- Windows Event Viewer.
- SQL Server Error Loge.
- sys.dm_exec_connections.
- Reading registry using **xp_instance_regread**.

```sql
DECLARE @portNumber NVARCHAR(10); 

EXEC xp_instance_regread @rootkey = ‘HKEY_LOCAL_MACHINE’, @key = ‘Software\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib\Tcp\IpAll’, @value_name = ‘TcpDynamicPorts’, @value = @portNumber OUTPUT; 

SELECT [Port Number] = @portNumber;
```

**What is FILE STREAM?**

FILE STREAM was introduced in SQL Server 2008 for the storage and management of unstructured data. The FILESTREAM feature allows storing BLOB data(word document, image file, music etc).

**How many default SQL Server error log files are generated?** 

* By default **7** SQL Server error log files was generated. **ERRORLOG** and **ERRORLOG.1** through **ERRORLOG.6.** 

* The name of the current log file is **ERRORLOG** with no extension. 

* The log is re-created every time that you restart SQL Server.

* When the **ERRORLOG** file is re-created,the previous log is renamed to **ERRORLOG.1,** and the next previous log (**ERRORLOG.1**) is renamed to **ERRORLOG.2**,and so on. **ERRORLOG.6** is deleted. 

**Is It possible to increase the retention of error log files?**

Yes,It is possible to change the number of error logs retention.

**Is there any possibility to find out the ‘SA’ password from log files?**

NO

Clear password not stored at anywhere.

**What is the Summary.txt file location in SQL Server?**

C:\Program Files\Microsoft SQL Server\(90\100\110\120\130\140\150)\Setup Bootstrap\Log.

**What information stored in Summary.txt file?**

Installation start and stop time, installed components, machine name, product, version and detailed log file information stored in this file.

**For SQL Server Setup installs what are the software components required?**

- Dot NET Framework
- SQL Server Native Client
- SQL Server Setup support files

**Where will you find the SQL Server installation related logs?**

*%programfiles%\Microsoft SQL Server\%version%\Setup Bootstrap\Log\\<YYYYMMDD_HHMM>\*

**What is “ConfigurationFile.ini” file?**

SQL Server Setup generates a configuration file named **ConfigurationFile.ini**, based upon the system default and run-time inputs.  The **ConfigurationFile.ini** file is a text file which contains the set of parameters in name/value pairs along with descriptive comments. Many of the parameter names correspond to the screens and options which you see while installing SQL Server through the wizard. We can then use the configuration file to install SQL Server with the same configuration instead of going through each of the installation screens.

*%programfiles%\Microsoft SQL Server\%version%\Setup Bootstrap\Log\\<YYYYMMDD_HHMM>\ConfigurationFile.ini*

**What is a service account?**

Based on the selected components while doing the installation we will find respective service to each component in the Windows Services. e.g. SQL Server, SQL Server Agent, SQL Analysis Services, SQL Server integration Services etc. There will be a user for each and every services through which each service will run. That use is called Service Account of that service.

Mainly we categorize the Service account as below:

* **Local User Account:** This user account is created in the server where SQL Server is installed; this account does not have access to network resources.
* **Local Service Account:** This is a built-in windows account that is available for configuring services in windows. This account has permissions as same as accounts that are in the users group, thus it has limited access to the resources in the server.
* **Local System Account:** This is a built-in windows account that is available for configuring services in windows. This is a highly privileged account that has access to all resources in the server with administrator rights.
* **Network Service Account**: This is a built-in windows account that is available for configuring services in windows. This has permissions to access resources in the network under the computer account.
* **Domain Account**: This account is a part of our domain that has access to network resources for which it is intended to have permission. It is always advised to run SQL Server and related services under a domain account with minimum privilege need to run SQL Server and its related services.

**Do we need to grant Administrator permissions on the Windows server to SQL Service account to run the services or not, why?**

No, it is not required. It’s not mandatory to grant Administrator permissions to the service account.

**What is a collation and what is the default collation?**

Collation refers to a set of rules that determine how data is sorted and compared. Character data is sorted using rules that define the correct character sequence, with options for specifying case-sensitivity, accent marks, kana character types and character width.

Default collation: ***SQL_Latin1_General_CP1_CI_AS\***

**What is an RTM setup of SQL Server?**

**RTM** stands for **release to manufacturing**.

**What is a Service Pack, Patch, Hot fix, Cumulative Update and its difference?**

* Service Pack - is abbreviated as SP, a service pack is a collection of updates and fixes, called patches, for an operating system or a software program. Many of these patches are often released before the larger service pack, but the service pack allows for an easy, single installation.

* Patch – Publicly released update to fix a known bug/issue

* Hotfix – update to fix a very specific issue, not always publicly released

* Cumulative Update - Each new CU contains all the fixes that were included with the previous CU for the installed version of **SQL Server**. **SQL Server** CUs are certified to the same levels as Service Packs, and should be installed at the same level of confidence.

**What’s the practical approach of installing Service Pack?**

Steps to install Service pack in Production environments:

1. First of all raise a change order and get the necessary approvals for the downtime window. Normally it takes around 45-60 minutes to install Service pack if there are no issues.
2. Once the downtime window is started, take a full backup of the user databases and system databases including the Resource database.
3. List down all the Startup parameters, Memory Usage, CPU Usage etc and save it in a separate file.
4. Install the service pack on SQL Servers.
5. Verify all the SQL Services are up and running as expected.
6. Validate the application functionality.

Note: There is a different approach to install Service pack on SQL Server cluster instances. That will be covered in SQL Server cluster.

**Is it mandatory to restart the Windows server after installing SQL server service pack?**

No, it’s not mandatory to restart Windows server after installing SQL Server service pack but it is always a good practice to do so.

**How to check the SQL Server version and Service pack installed on the server?**

```sql
SELECT CONVERT(VARCHAR(50), SERVERPROPERTY('productversion')),
       CONVERT(VARCHAR(50), SERVERPROPERTY('productlevel')),
       CONVERT(VARCHAR(50), SERVERPROPERTY('edition'))
```

Or

```sql
SELECT @@VERSION
```

**How to check SQL Server name?**

```sql
SELECT @@SERVERNAME
```

**Is it possible to increase the retention of Error log files and How?**

Yes 

It is possible to change the no. of Error logs retention

**Difference between Enterprise and Standard Editions?**

Enterprise Edition

- For large scale applications
- Supports all features of SS
- DB Snapshots
- Online Restores
- Peer-Peer replication
- Mirroring with all features
- Oracle Publishing
- No limit for no of CPUs and Users 
- Basically for cluster based
- Multi-instances supported (50)

**How many files can a Database contain in SQL Server? How many types of data files exists in SQL Server? How many of those files can exist for a single database?**

**Answer:**  A Database can contain a maximum of 32,767 files.

There are Primarily 2 types of data files Primary data file and Secondary data file(s)

There can be only one Primary data file and multiple secondary data files as long as the total # of files is less than 32,767 files.

**What are the things to be considered to install new SQL Server instance?**
**Note:** Question can be asked related to different versions of SQL Server, but general steps will be applicable for during installation of all versions of SQL Server.

* Prepare documentation and implement the required Hardware and Software which includes Operating System, OS patches, features like clustering, .Net framework, etc
* Study and document the SQL Server features which need to be implemented. Example, to use AlwaysON, need to have windows clustering feature enabled and other requirements need to be understood and documented
* Study, document and implement all the pre-requisites required for the installation of SQL Server.
* Install SQL Server version.
* Apply latest Service Packs or Cumulative Updates or Security Updates.
* Check the Setup logs and Event logs and make sure there are no errors related to OS or SQL Server.
* Test and make sure you can connect to SQL Server from remote systems and all features which are installed are working properly.

**How do you determine whether to apply latest Service Packs or Cumulative Updates?** **
Some of the common reasons for installing Service Packs or Cumulative Updates.

* If SQL Server is experiencing any known issue and it is found that the issue was fixed on a particular Service Pack or CU, then need to test the patch by applying on a test server and if application is working fine, then can go ahead and install the patches on production server.
* Security Updates are releases when some vulnerability is identified with the product, so need to apply these as soon as it is available.
* Service Packs can be applied as they are more safe than Cumulative updates. In general after a service pack is released, CU1 for that service pack will be released very soon, so good practice to apply a service pack as soon as it is available and then also install the CU1. Of-course, Service Pack should be first installed on Test server and application should be tested thoroughly to make sure it works without any problems. 
* It is always good to be on latest build of SQL Server to avoid any known issues before they cause production issues. Quarterly patching of SQL Servers should be good.

**Can a Service Pack or Cumulative Update be uninstalled to rolled back in case of failures?**
Yes

Version 2008+

**Should we manage the limit of memory used by SQL Server? How can you do this? **

Yes

By default, the limit is set to 2147483647 MB. We can change setting via:

* SSMS > Server properties > Memory
* SQL

```sql
EXEC sys.sp_configure N'show advanced options', N'1' RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'max server memory (MB)', N'xxx'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0' RECONFIGURE WITH OVERRIDE
GO
```

### Maintain Instances and Databases

**What is filegroups and their benefits?**

File Group is the logical unit that works as a container for data files. We can place multiple data files in to a filegroup. Filegroups are very helpful in below cases:

1. If you have big database and you want to reduce the recovery time in case of any failure. You can plan filegroup backups that can be used for partial restores and data will be accessible while corresponding filegroup will be restored. Even you can run backup of an individual filegroup only.
2. You can segregate your critical data into separate filegroup and non-critical data into another filegroup. You can also place them on separate drives/RAIDs to reduce DISK IO.
3. Another advantage is that you can keep your filegroup in to read only mode. If you don’t want to run any DML statement on some of the tables, you can place all those tables into separate file group and change that file group into read only mode.

**How many types of filegroup available in SQL Server and Log files belong to which file group?**

There are two types of filegroup.

1. Primary Filegroup
2. Secondary Filegroup

A database will have only one Primary Filegroup and can have as much as 32767 secondary filegroups. When we create a database primary filegroup created automatically. Primary data file will be part of primary filegroup. You can add maximum 32767 data files in a single filegroup.

Log files does not belong to any filegroup.

**What is database files and how many types of database files are there in SQL Server Database?**

Database files are the physical files that are created on OS drives when you create a SQL Server Database. These files are used to store actual data and log records of the transactions. There are two types of database files.

- Data File
- Log File

Data files further categorized into two types.

- Primary Data File
- Secondary Data File

**How SQL Server stores logs in transaction log file?**

SQL Server stores logs serially in transaction log file.  Transaction log is a string of log records. Each log record is identified by a log sequence number (LSN). Each new log record is written with the incremental LSN that means a new log record will be assigned a LSN that is higher than the LSN of the record before it

**What is virtual log file?**

Each transaction log file internally divided into several virtual log files. Virtual log files have no fixed size, and there is no fixed number of virtual log files for a physical log file.

**By default, your log file belongs to which filegroup?**

Log files do not belong to any file group.

**Do you think multiple log files are useful in SQL Server?**

Yes, it will be helpful in case you are dealing with space issues. You can add additional log files in another drive if you stuck by spaces issue in log file/drive during data load/Import. You can also create additional log file in to another drive if you are frequently facing space issue and cannot extent the existing log file drive.

**Explain Checkpoint operation in SQL Server?**

A checkpoint writes the current in-memory modified pages (known as *dirty pages*) and transaction log information from memory to disk in data files.

**How many types of checkpoint SQL Server Supports?**

There are four types of checkpoint SQL Server supports.

1. Automatic Checkpoint
2. Indirect Checkpoint
3. Manual Checkpoint
4. Internal Checkpoint

**What is Instant File Initialization and its benefits?**

SQL Server has a feature called **Instant file initialization** that allows fast data file allocations of the all data file operations. **Instant file initialization** reclaims used disk space without filling that space with zeros.

**How do you know that Instant File Initialization is enabled on your SQL Server Instance?**

You can see the SQL Server error log file. When SQL Server starts, it captures this information whether Instant File Initialization is enabled for this instance or not. I have explained this also in above attached article.

**What is Minimal Logging and how is it different from Full Logging?**

Minimal logging involves logging only information that is required to recover the transaction without supporting **point-in-time recovery**. Under the **full recovery model**, all bulk operations are fully logged. However, you can minimize logging for a set of bulk operations by switching the database to the **bulk-logged recovery model** temporarily for bulk operations.

Minimal logging is more efficient than full logging, and it reduces the possibility of a large-scale bulk operation filling the available **transaction log** space during a bulk transaction. However, if the database is damaged or lost when minimal logging is in effect, you cannot recover the database to the point of failure.

**Can you name few operations that logs Minimally during bulk-recovery model?**

The following operations, which are fully logged under the full recovery model, are minimally logged under bulk-logged recovery model:

1. Bulk import operations (bcp, BULK INSERT, and INSERT… SELECT).
2. SELECT INTO operations
3. CREATE INDEX operations
4. ALTER INDEX REBUILD or DBCC DBREINDEX operations.
5. DROP INDEX new heap rebuild

**If I change my database recovery model from FULL to SIMPLE, does transactions will be logged in to log file?**

Yes, Transactions will be logged in SIMPLE recovery model as well. The difference is all logged transactions will be cleared during checkpoint operation in this recovery model

**How is SIMPLE RECOVERY Model different from FULL Recovery Model?**

All logged transactions will be cleared during checkpoint operation and transaction log backup is not allowed so point-in-time recovery is not possible in SIMPLE recovery model. Whereas transaction backup is allowed in full recovery model and point-in-time recovery is also supported. Logs got cleared only after taking log backup or switching the recovery model to SIMPLE.

**Can we achieve point-in-time recovery in Bulk-logged Recovery Model?**

Yes, if there is no bulk operation performed on your database and you have all log backups. Point-in-time recovery is not possible if your recovery point falls falls in-between any bulk operations. .

**How differential backup works? or How differential backup captures only updated data since full backup in its dump file?**

**Differential Changed Map** is a page type that stores information about extents that have changed since the last full backup. Database engine reads just the DCM pages to determine which extents have been modified and captures those extents in differential backup file.

**Why cannot we serve copy-only backup as a differential base or differential backup?**

The differential changed map page is not updated by a **copy-only backup**. Therefore, a copy-only backup cannot serve as a differential base or differential backup. A copy-only backup does not affect subsequent differential backups.

**Why a database log file is growing like anything that is running in SIMPLE Recovery Model?**

It means some transactions are active and running on your database. As we know logs are captured in simple recovery model as well so that active transaction is getting logged there. The inactive portion in log file clears during checkpoint operation.

