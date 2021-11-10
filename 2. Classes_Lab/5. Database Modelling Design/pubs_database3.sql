CREATE DATABASE pubs
GO

USE pubs
GO

execute sp_addtype id, 'varchar(11)', 'NOT NULL'
GO

execute sp_addtype tid, 'varchar(6)', 'NOT NULL'
GO

execute sp_addtype empid, 'char(9)', 'NOT NULL'
GO

CREATE TABLE Authors
(
   au_id	id

         CHECK (au_id like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]')

         CONSTRAINT UPKCL_auidind PRIMARY KEY CLUSTERED,

   au_fname       varchar(40)       NOT NULL,
   au_lname       varchar(20)       NOT NULL,

   phone          char(12)          NOT NULL

         DEFAULT ('UNKNOWN'),

   address        varchar(40)           NULL,
   city           varchar(20)           NULL,
   province	  char(2)               NULL,

   zip            char(5)               NULL

         CHECK (zip like '[0-9][0-9][0-9][0-9][0-9]'),

   contract       bit               NOT NULL
)
GO

CREATE TABLE Publishers
(
   PubID         char(4)           NOT NULL

         CONSTRAINT UPKCL_pubind PRIMARY KEY CLUSTERED

         CHECK (PubID in ('1389', '0736', '0877', '1622', '1756')
            OR PubID like '99[0-9][0-9]'),

   PubName       varchar(40)           NULL,
   city          varchar(20)           NULL,
   province      char(2)               NULL,

   country        varchar(30)           NULL

         DEFAULT('USA')
)
GO

CREATE TABLE Books
(
   TitleId       tid

         CONSTRAINT UPKCL_title_idind PRIMARY KEY CLUSTERED,

   title          varchar(80)       NOT NULL,

   type           char(12)          NOT NULL

         DEFAULT ('UNDECIDED'),

   PubID         char(4)               NULL

         REFERENCES Publishers(PubID),

   price          money                 NULL,
   advance        money                 NULL,
   royalty        int                   NULL,
   ytd_Sales      int                   NULL,
   notes          varchar(200)          NULL,

   pubdate        datetime          NOT NULL

         DEFAULT (getdate())
)
GO

CREATE TABLE titleauthor
(
   au_id          id

         REFERENCES Authors(au_id),

   TitleId       tid

         REFERENCES Books(TitleId),

   au_ord         tinyint               NULL,
   royaltyper     int                   NULL,


   CONSTRAINT UPKCL_taind PRIMARY KEY CLUSTERED(au_id, TitleId)
)
GO

CREATE TABLE Stores
(
   StorID        char(4)           NOT NULL

         CONSTRAINT UPK_storeid PRIMARY KEY CLUSTERED,

   stor_name      varchar(40)           NULL,
   stor_address   varchar(40)           NULL,
   city           varchar(20)           NULL,
   province       char(2)               NULL,
   zip            char(5)               NULL
)
GO

CREATE TABLE Sales
(
   StorID        char(4)           NOT NULL

         REFERENCES Stores(StorID),

   ord_num        varchar(20)       NOT NULL,
   ord_date       datetime          NOT NULL,
   qty            smallint          NOT NULL,
   payterms       varchar(12)       NOT NULL,

   TitleID       tid

         REFERENCES Books(TitleId),


   CONSTRAINT UPKCL_Sales PRIMARY KEY CLUSTERED (StorID, ord_num, TitleId)
)
GO

CREATE TABLE roysched
(
   TitleId       tid

         REFERENCES Books(TitleId),

   lorange        int                   NULL,
   hirange        int                   NULL,
   royalty        int                   NULL
)
GO

CREATE TABLE Discounts
(
   discounttype   varchar(40)       NOT NULL,

   StorID        char(4) NULL

         REFERENCES Stores(StorID),

   lowqty         smallint              NULL,
   highqty        smallint              NULL,
   discount       dec(4,2)          NOT NULL
)
GO

CREATE TABLE jobs
(
   job_id         smallint          IDENTITY(1,1)

         PRIMARY KEY CLUSTERED,

   job_desc       varchar(50)       NOT NULL

         DEFAULT 'New Position - title not formalized yet',

   min_lvl        tinyint           NOT NULL

         CHECK (min_lvl >= 10),

   max_lvl        tinyint           NOT NULL

         CHECK (max_lvl <= 250)
)
GO

CREATE TABLE pub_info
(
   PubID         char(4)           NOT NULL

         REFERENCES Publishers(PubID)

         CONSTRAINT UPKCL_pubinfo PRIMARY KEY CLUSTERED,

   logo           image                 NULL,
   pr_info        text                  NULL
)
GO

CREATE TABLE Employees
(
   emp_id         empid

         CONSTRAINT PK_emp_id PRIMARY KEY NONCLUSTERED

         CONSTRAINT CK_emp_id CHECK (emp_id LIKE
            '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]' or
            emp_id LIKE '[A-Z]-[A-Z][1-9][0-9][0-9][0-9][0-9][FM]'),

   FirstName	  varchar(20)       NOT NULL,
   minit          char(1)           NULL,
   LastName       varchar(30)       NOT NULL,

   job_id         smallint          NOT NULL

         DEFAULT 1

         REFERENCES jobs(job_id),

   job_lvl        tinyint

         DEFAULT 10,
	
   PubID         char(4)           NOT NULL

         DEFAULT ('9952')

         REFERENCES Publishers(PubID),

   HireDate      datetime          NOT NULL

         DEFAULT (getdate()),

   PhoneNumber varchar(20)	   NULL
)
GO

insert Authors
   values('409-56-7008', 'Bennet', 'Abraham', '415 658-9932',
   '6223 Bateman St.', 'Berkeley', 'CA', '94705', 1)
insert Authors
   values('213-46-8915', 'Green', 'Marjorie', '415 986-7020',
   '309 63rd St. #411', 'Oakland', 'CA', '94618', 1)
insert Authors
   values('238-95-7766', 'Carson', 'Cheryl', '415 548-7723',
   '589 Darwin Ln.', 'Berkeley', 'CA', '94705', 1)
insert Authors
   values('998-72-3567', 'Ringer', 'Albert', '801 826-0752',
   '67 Seventh Av.', 'Salt Lake City', 'UT', '84152', 1)
insert Authors
   values('899-46-2035', 'Ringer', 'Anne', '801 826-0752',
   '67 Seventh Av.', 'Salt Lake City', 'UT', '84152', 1)
insert Authors
   values('722-51-5454', 'DeFrance', 'Michel', '219 547-9982',
   '3 Balding Pl.', 'Gary', 'IN', '46403', 1)
insert Authors
   values('807-91-6654', 'Panteley', 'Sylvia', '301 946-8853',
   '1956 Arlington Pl.', 'Rockville', 'MD', '20853', 1)
insert Authors
   values('893-72-1158', 'McBadden', 'Heather',
   '707 448-4982', '301 Putnam', 'Vacaville', 'CA', '95688', 0)
insert Authors
   values('724-08-9931', 'Stringer', 'Dirk', '415 843-2991',
   '5420 Telegraph Av.', 'Oakland', 'CA', '94609', 0)
insert Authors
   values('274-80-9391', 'Straight', 'Dean', '415 834-2919',
   '5420 College Av.', 'Oakland', 'CA', '94609', 1)
insert Authors
   values('756-30-7391', 'Karsen', 'Livia', '415 534-9219',
   '5720 McAuley St.', 'Oakland', 'CA', '94609', 1)
insert Authors
   values('724-80-9391', 'MacFeather', 'Stearns', '415 354-7128',
   '44 Upland Hts.', 'Oakland', 'CA', '94612', 1)
insert Authors
   values('427-17-2319', 'Dull', 'Ann', '415 836-7128',
   '3410 Blonde St.', 'Palo Alto', 'CA', '94301', 1)
insert Authors
   values('672-71-3249', 'Yokomoto', 'Akiko', '415 935-4228',
   '3 Silver Ct.', 'Walnut Creek', 'CA', '94595', 1)
insert Authors
   values('267-41-2394', 'O''Leary', 'Michael', '408 286-2428',
   '22 Cleveland Av. #14', 'San Jose', 'CA', '95128', 1)
insert Authors
   values('472-27-2349', 'Gringlesby', 'Burt', '707 938-6445',
   'PO Box 792', 'Covelo', 'CA', '95428', 3)
insert Authors
   values('527-72-3246', 'Greene', 'Morningstar', '615 297-2723',
   '22 Graybar House Rd.', 'Nashville', 'TN', '37215', 0)
insert Authors
   values('172-32-1176', 'White', 'Johnson', '408 496-7223',
   '10932 Bigge Rd.', 'Menlo Park', 'CA', '94025', 1)
insert Authors
   values('712-45-1867', 'del Castillo', 'Innes', '615 996-8275',
   '2286 Cram Pl. #86', 'Ann Arbor', 'MI', '48105', 1)
insert Authors
   values('846-92-7186', 'Hunter', 'Sheryl', '415 836-7128',
   '3410 Blonde St.', 'Palo Alto', 'CA', '94301', 1)
insert Authors
   values('486-29-1786', 'Locksley', 'Charlene', '415 585-4620',
   '18 Broadway Av.', 'San Francisco', 'CA', '94130', 1)
insert Authors
   values('648-92-1872', 'Blotchet-Halls', 'Reginald', '503 745-6402',
   '55 Hillsdale Bl.', 'Corvallis', 'OR', '97330', 1)
insert Authors
   values('341-22-1782', 'Smith', 'Meander', '913 843-0462',
   '10 Mississippi Dr.', 'Lawrence', 'KS', '66044', 0)

insert Publishers values('0736', 'New Moon Books', 'Boston', 'MA', 'USA')
insert Publishers values('0877', 'Binnet & Hardley', 'Washington', 'DC', 'USA')
insert Publishers values('1389', 'Algodata Infosystems', 'Berkeley', 'CA', 'USA')
insert Publishers values('9952', 'Scootney Books', 'New York', 'NY', 'USA')
insert Publishers values('1622', 'Five Lakes Publishing', 'Chicago', 'IL', 'USA')
insert Publishers values('1756', 'Ramona Publishers', 'Dallas', 'TX', 'USA')
insert Publishers values('9901', 'GGG&G', 'Mnchen', NULL, 'Germany')
insert Publishers values('9999', 'Lucerne Publishing', 'Paris', NULL, 'France')

insert pub_info values('1756', 0x474946383961E3002500B30F00000000800000008000808000000080800080008080808080C0C0C0FF000000FF00FFFF000000FFFF00FF00FFFFFFFFFF21F9040100000F002C00000000E30025004004FFF0C949ABBD38EBCDBBFF60288E240858E705A4D2EA4E6E0CC7324DD1EB9CDBBAFCE1AC878DE7ABBD84476452C963369F2F288E933A595B404DB27834E67A5FEC37ACEC517D4EB24E5C8D069966361A5E8ED3C3DCA5AA54B9B2AE2D423082817F848286898386858754887B8A8D939094947E918B7D8780959E9D817C18986FA2A6A75A7B22A59B378E1DACAEB18F1940B6A8B8A853727AB5BD4E76676A37BFB9AF2A564D6BC0776E635BCE6DCFD2C3C873716879D4746C6053DA76E0DAB3A133D6D5B290929F9CEAEDEB6FA0C435EF9E97F59896EC28EEFA9DFF69A21C1BB4CA1E3E63084DB42B970FD6407D05C9E59298B0A2C58B18337AA0E88DA3468DC3FFD0692187A7982F5F2271B152162DE54795CEB0F0DAF8EBDA2A932F1FF203B38C484B6ED07674194ACD639679424B4EDB36279B4D3852FE1095266743955138C5209ADA6D5CB26DCDFC644DD351EACF804BCD32421A562DB6965F25AADD11B056BD7BA436C903E82A1D4A3D024769BAE777B0BB7887F51A0E022E9589BCFCE0DD6527597223C4917502ACBCF8D5E6C49F0B6FA60751A7C2748A3EE7DD6B70B5628F9A5873C6DB5936E57EB843C726043B95EBDE394F3584EC7096ED8DA60D86001EBCB9F3E72F99439F0E7DEC7297BA84D9924EFDB11A65566B8EFB510C7CC258DBB7779F7834A9756E6C97D114F95E5429F13CE5F7F9AAF51C996928604710FF544AFDC79717C10CD85157C6EDD75F7EB49C81D45C5EA9674E5BBBA065941BFB45F3D62D5E99E11488516568A15D1292255F635E8045E0520F3E15A0798DB5C5A08105EE52E3884C05255778E6F5C4A287CCB4D84D1D41CE08CD913C56656482EAEDE8E38D71B974553C199EC324573C3669237C585588E52D1ACE049F85521648659556CD83445D27C9F4D68501CE580E31748ED4948C0E3E88959B257C87E39D0A8EC5D812559234996A9EE5B6E864FE31BA5262971DE40FA5B75D9A487A9A79975C6AB5DD06EA6CCA9DB94FA6A1568AD8A4C33DBA6A5995EE5450AC0AA24A9C6DBAE9F6883CB48976D0ABA8D90AA9A88D6246C2ABA3FE8A1B43CA229B9C58AFC11E071AB1D1BE366DB5C9AE85DCA48595466B83AC95C61DA60D1146EEB3BB817ADA40A08CFBDBB2EB9972EB6EDB66D26D71768D5B2B1FEFC65B11AFA5FA96C93AF50AA6AFBEFE263C1DC0FCA2AB8AC210472C310A1100003B,
'This is sample text data for Ramona Publishers, publisher 1756 in the pubs database. Ramona Publishers is located in Dallas, Texas.')

insert pub_info values('9901', 0x4749463839615D002200B30F00000000800000008000808000000080800080008080808080C0C0C0FF000000FF00FFFF000000FFFF00FF00FFFFFFFFFF21F9040100000F002C000000005D0022004004FFF0C949ABBD38EBCDFB03DF078C249895A386AA68BB9E6E0ACE623ABD1BC9E9985DFFB89E8E366BED782C5332563ABA4245A6744AAD5AAF4D2276CBED5EA1D026C528B230CD38B2C92721D78CC4772526748F9F611EB28DE7AFE25E818283604A1E8788898A7385838E8F55856F6C2C1D86392F6B9730708D6C5477673758A3865E92627E94754E173697A6A975809368949BB2AE7B9A6865AA734F80A2A17DA576AA5BB667C290CDCE4379CFD2CE9ED3D6A7CCD7DAA4D9C79341C8B9DF5FC052A8DEBA9BB696767B9C7FD5B8BBF23EABB9706BCAE5F05AB7E6C4C7488DDAF7251BC062530EFE93638C5B3580ECD4951312C217C425E73E89D38709D79D810D393BD20A528CE0AA704AA2D4D3082E583C89BD2C2D720753E1C8922697D44CF6AE53BF6D4041750B4AD467C54548932A1D7374A9D3A789004400003B,
'This is sample text data for GGG&G, publisher 9901 in the pubs database. GGG&G is located in München, Germany.')

insert pub_info values('9952', 0x47494638396107012800B30F00000000800000008000808000000080800080008080808080C0C0C0FF000000FF00FFFF000000FFFF00FF00FFFFFFFFFF21F9040100000F002C00000000070128004004FFF0C949ABBD38EBCDBBFF60288E6469660005AC2C7BB56D05A7D24C4F339E3F765FC716980C3824F28418E4D1A552DA8ACCA5517A7B526F275912690D2A9BD11D14AB8B8257E7E9776BDEE452C2279C47A5CBEDEF2B3C3FBF9FC85981821D7D76868588878A898C8B838F1C8D928E733890829399949B979D9E9FA074A1A3A4A5A6A7458F583E69803F53AF4C62AD5E6DB13B6B3DAEAC6EBA64B365B26BB7ABBEB5C07FB428BCC4C8C1CCC7BBB065637C7A9B7BBE8CDADBDA8B7C31D9E1D88E2FA89E9AE9E49AE7EDA48DA2EEF2F3F4F597AEF6F9FAFBFC805D6CD28C0164C64D18BE3AAD88D87AA5C1DBC07FD59CE54293F0E0882AC39ED9CA2886E3308FB3FF262EBC726D591823204F2E0C09A4A3B32CFEACBC24198D86C48FD3E208D43832E3C0671A2D89737167281AA333219AC048D061499A3C83BEC8090BD84E5A99DE808B730DE9516B727CE85AE7C122BF73EAD29255CB76ADDBB6EC549C8504F7AD5DB37343A98D97576EDDBF7CFB0AEE8457EF5D4E83132BAEB1B8B1E3C749204B9EACB830E5CB984DE1F339A4E1CC88C93CB7D989D72234D1D3A672FEF85055C483C80A06742ADB664F3563119E417D5A8F52DFB1512AEC5D82E9C8662A477FB19A72B6F2E714413F8D0654AA75A8C4C648FDBC346ACDCD5487AFC439BE8BC8E8AA7F6BD77D2B7DF4E6C5882E57DFBDE2F56AEE6D87DFB8BFE06BE7E8F1C6CBCE4D2DC15751803C5956567EFA1D47A041E5F1176183CC1D571D21C2850396565CF5B1D5571D8AC21D08E099A15E85269E87207B1736B31E6FE620324E582116F5215178C86763518A9068DF7FE8C9C6207DCD0104A47B6B717388901EFA27238E3482454E43BB61E8D388F7FD44DD32473E79D43A527633232561E6F86536660256891699D175989A6F1A020A9C75C9D5E68274C619D79D91B5C5189F7906CA67297129D88F9E881A3AA83E8AB623E85E8B0EDAE89C892216E9A584B80318A69C7E3269A7A046FA69A8A4B6094004003B,
'This is sample text data for Scootney Books, publisher 9952 in the pubs database. Scootney Books is located in New York City, New York.')

insert pub_info values('9999', 0x474946383961A9002400B30F00000000800000008000808000000080800080008080808080C0C0C0FF000000FF00FFFF000000FFFF00FF00FFFFFFFFFF21F9040100000F002C00000000A90024004004FFF0C949ABBD38EBCDBBFF60F8011A609E67653EA8D48A702CCFF44566689ED67CEFFF23D58E7513B686444A6EA26B126FC8E74AC82421A7ABE5F4594D61B7BBF0D6F562719A68A07ACDC6389925749AFC6EDBEFBCA24D3E96E2FF803D7A1672468131736E494A8B5C848D8633834B916E598B657E4A83905F7D9B7B56986064A09BA2A68D63603A2E717C9487B2B3209CA7AD52594751B4BD80B65D75B799BEC5BFAF7CC6CACB6638852ACC409F901BD33EB6BCCDC1D1CEA9967B23C082C3709662A69FA4A591E7AE84D87A5FA0AB502F43AC5D74EB9367B0624593FA5CB101ED144173E5F4315AE8485B4287FCBE39E446B1624173FEAC59DC2809594623D9C3388A54E4ACD59C642353E2F098E919319530DD61C405C7CBCB9831C5E5A2192C244E983A3FFE1CDA21282CA248ABB18C25336952A389D689E489B0D24483243B66CD8775A315801AA5A60A6B2DAC074E3741D6BBA8902BA687E9A6D1A3B6D6D15C7460C77AA3E3E556D79EBAF4AAAAB2CFCF578671DFDE657598305D51F7BE5E5A25361ED3388EED0A84B2B7535D6072C1D62DB5588BE5CCA5B1BDA377B99E3CBE9EDA31944A951ADF7DB15263A1429B37BB7E429D8EC4D754B87164078F2B87012002003B,
'This is sample text data for Lucerne Publishing, publisher 9999 in the pubs database. Lucerne publishing is located in Paris, France.')

insert Books values ('PC8888', 'Secrets of Silicon Valley', 'popular_comp', '1389',
$20.00, $8000.00, 10, 4095,
'Muckraking reporting on the world''s largest computer hardware and software manufacturers.',
'06/12/94')

insert Books values ('BU1032', 'The Busy Executive''s Database Guide', 'business',
'1389', $19.99, $5000.00, 10, 4095,
'An overview of available database systems with emphasis on common business applications. Illustrated.',
'06/12/91')

insert Books values ('PS7777', 'Emotional Security: A New Algorithm', 'psychology',
'0736', $7.99, $4000.00, 10, 3336,
'Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.',
'06/12/91')

insert Books values ('PS3333', 'Prolonged Data Deprivation: Four Case Studies',
'psychology', '0736', $19.99, $2000.00, 10, 4072,
'What happens when the data runs dry?  Searching evaluations of information-shortage effects.',
'06/12/91')

insert Books values ('BU1111', 'Cooking with Computers: Surreptitious Balance Sheets',
'business', '1389', $11.95, $5000.00, 10, 3876,
'Helpful hints on how to use your electronic resources to the best advantage.',
'06/09/91')

insert Books values ('MC2222', 'Silicon Valley Gastronomic Treats', 'mod_cook', '0877',
$19.99, $0.00, 12, 2032,
'Favorite recipes for quick, easy, and elegant meals.',
'06/09/91')

insert Books values ('TC7777', 'Sushi, Anyone?', 'trad_cook', '0877', $14.99, $8000.00,
10, 4095,
'Detailed instructions on how to make authentic Japanese sushi in your spare time.',
'06/12/91')

insert Books values ('TC4203', 'Fifty Years in Buckingham Palace Kitchens', 'trad_cook',
'0877', $11.95, $4000.00, 14, 15096,
'More anecdotes from the Queen''s favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.',
'06/12/91')

insert Books values ('PC1035', 'But Is It User Friendly?', 'popular_comp', '1389',
$22.95, $7000.00, 16, 8780,
'A survey of software for the naive user, focusing on the ''friendliness'' of each.',
'06/30/91')

insert Books values('BU2075', 'You Can Combat Computer Stress!', 'business', '0736',
$2.99, $10125.00, 24, 18722,
'The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.',
'06/30/91')

insert Books values('PS2091', 'Is Anger the Enemy?', 'psychology', '0736', $10.95,
$2275.00, 12, 2045,
'Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.',
'06/15/91')

insert Books values('PS2106', 'Life Without Fear', 'psychology', '0736', $7.00, $6000.00,
10, 111,
'New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.',
'10/05/91')

insert Books values('MC3021', 'The Gourmet Microwave', 'mod_cook', '0877', $2.99,
$15000.00, 24, 22246,
'Traditional French gourmet recipes adapted for modern microwave cooking.',
'06/18/91')

insert Books values('TC3218', 'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean',
'trad_cook', '0877', $20.95, $7000.00, 10, 375,
'Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.',
'10/21/91')

insert Books (TitleId, title, PubID) values('MC3026',
'The Psychology of Computer Cooking', '0877')

insert Books values ('BU7832', 'Straight Talk About Computers', 'business', '1389',
$19.99, $5000.00, 10, 4095,
'Annotated analysis of what computers can do for you: a no-hype guide for the critical user.',
'06/22/91')

insert Books values('PS1372', 'Computer Phobic AND Non-Phobic Individuals: Behavior Variations',
'psychology', '0877', $21.59, $7000.00, 10, 375,
'A must for the specialist, this book examines the difference between those who hate and fear computers and those who don''t.',
'10/21/91')

insert Books (TitleId, title, type, PubID, notes) values('PC9999', 'Net Etiquette',
'popular_comp', '1389', 'A must-read for computer conferencing.')

insert titleauthor values('409-56-7008', 'BU1032', 1, 60)
insert titleauthor values('486-29-1786', 'PS7777', 1, 100)
insert titleauthor values('486-29-1786', 'PC9999', 1, 100)
insert titleauthor values('712-45-1867', 'MC2222', 1, 100)
insert titleauthor values('172-32-1176', 'PS3333', 1, 100)
insert titleauthor values('213-46-8915', 'BU1032', 2, 40)
insert titleauthor values('238-95-7766', 'PC1035', 1, 100)
insert titleauthor values('213-46-8915', 'BU2075', 1, 100)
insert titleauthor values('998-72-3567', 'PS2091', 1, 50)
insert titleauthor values('899-46-2035', 'PS2091', 2, 50)
insert titleauthor values('998-72-3567', 'PS2106', 1, 100)
insert titleauthor values('722-51-5454', 'MC3021', 1, 75)
insert titleauthor values('899-46-2035', 'MC3021', 2, 25)
insert titleauthor values('807-91-6654', 'TC3218', 1, 100)
insert titleauthor values('274-80-9391', 'BU7832', 1, 100)
insert titleauthor values('427-17-2319', 'PC8888', 1, 50)
insert titleauthor values('846-92-7186', 'PC8888', 2, 50)
insert titleauthor values('756-30-7391', 'PS1372', 1, 75)
insert titleauthor values('724-80-9391', 'PS1372', 2, 25)
insert titleauthor values('724-80-9391', 'BU1111', 1, 60)
insert titleauthor values('267-41-2394', 'BU1111', 2, 40)
insert titleauthor values('672-71-3249', 'TC7777', 1, 40)
insert titleauthor values('267-41-2394', 'TC7777', 2, 30)
insert titleauthor values('472-27-2349', 'TC7777', 3, 30)
insert titleauthor values('648-92-1872', 'TC4203', 1, 100)

insert Stores values('7066','Barnum''s','567 Pasadena Ave.','Tustin','CA','92789')
insert Stores values('7067','News & Brews','577 First St.','Los Gatos','CA','96745')
insert Stores values('7131','Doc-U-Mat: Quality Laundry and Books','24-A Avogadro Way','Remulade','WA','98014')
insert Stores values('8042','Bookbeat','679 Carson St.','Portland','OR','89076')
insert Stores values('6380','Eric the Read Books','788 Catamaugus Ave.','Seattle','WA','98056')
insert Stores values('7896','Fricative Bookshop','89 Madison St.','Fremont','CA','90019')

insert Sales values('7066', 'QA7442.3', '09/13/94', 75, 'ON invoice','PS2091')
insert Sales values('7067', 'D4482', '09/14/94', 10, 'Net 60','PS2091')
insert Sales values('7131', 'N914008', '09/14/94', 20, 'Net 30','PS2091')
insert Sales values('7131', 'N914014', '09/14/94', 25, 'Net 30','MC3021')
insert Sales values('8042', '423LL922', '09/14/94', 15, 'ON invoice','MC3021')
insert Sales values('8042', '423LL930', '09/14/94', 10, 'ON invoice','BU1032')
insert Sales values('6380', '722a', '09/13/94', 3, 'Net 60','PS2091')
insert Sales values('6380', '6871', '09/14/94', 5, 'Net 60','BU1032')
insert Sales values('8042','P723', '03/11/93', 25, 'Net 30', 'BU1111')
insert Sales values('7896','X999', '02/21/93', 35, 'ON invoice', 'BU2075')
insert Sales values('7896','QQ2299', '10/28/93', 15, 'Net 60', 'BU7832')
insert Sales values('7896','TQ456', '12/12/93', 10, 'Net 60', 'MC2222')
insert Sales values('8042','QA879.1', '5/22/93', 30, 'Net 30', 'PC1035')
insert Sales values('7066','A2976', '5/24/93', 50, 'Net 30', 'PC8888')
insert Sales values('7131','P3087a', '5/29/93', 20, 'Net 60', 'PS1372')
insert Sales values('7131','P3087a', '5/29/93', 25, 'Net 60', 'PS2106')
insert Sales values('7131','P3087a', '5/29/93', 15, 'Net 60', 'PS3333')
insert Sales values('7131','P3087a', '5/29/93', 25, 'Net 60', 'PS7777')
insert Sales values('7067','P2121', '6/15/92', 40, 'Net 30', 'TC3218')
insert Sales values('7067','P2121', '6/15/92', 20, 'Net 30', 'TC4203')
insert Sales values('7067','P2121', '6/15/92', 20, 'Net 30', 'TC7777')

insert roysched values('BU1032', 0, 5000, 10)
insert roysched values('BU1032', 5001, 50000, 12)
insert roysched values('PC1035', 0, 2000, 10)
insert roysched values('PC1035', 2001, 3000, 12)
insert roysched values('PC1035', 3001, 4000, 14)
insert roysched values('PC1035', 4001, 10000, 16)
insert roysched values('PC1035', 10001, 50000, 18)
insert roysched values('BU2075', 0, 1000, 10)
insert roysched values('BU2075', 1001, 3000, 12)
insert roysched values('BU2075', 3001, 5000, 14)
insert roysched values('BU2075', 5001, 7000, 16)
insert roysched values('BU2075', 7001, 10000, 18)
insert roysched values('BU2075', 10001, 12000, 20)
insert roysched values('BU2075', 12001, 14000, 22)
insert roysched values('BU2075', 14001, 50000, 24)
insert roysched values('PS2091', 0, 1000, 10)
insert roysched values('PS2091', 1001, 5000, 12)
insert roysched values('PS2091', 5001, 10000, 14)
insert roysched values('PS2091', 10001, 50000, 16)
insert roysched values('PS2106', 0, 2000, 10)
insert roysched values('PS2106', 2001, 5000, 12)
insert roysched values('PS2106', 5001, 10000, 14)
insert roysched values('PS2106', 10001, 50000, 16)
insert roysched values('MC3021', 0, 1000, 10)
insert roysched values('MC3021', 1001, 2000, 12)
insert roysched values('MC3021', 2001, 4000, 14)
insert roysched values('MC3021', 4001, 6000, 16)
insert roysched values('MC3021', 6001, 8000, 18)
insert roysched values('MC3021', 8001, 10000, 20)
insert roysched values('MC3021', 10001, 12000, 22)
insert roysched values('MC3021', 12001, 50000, 24)
insert roysched values('TC3218', 0, 2000, 10)
insert roysched values('TC3218', 2001, 4000, 12)
insert roysched values('TC3218', 4001, 6000, 14)
insert roysched values('TC3218', 6001, 8000, 16)
insert roysched values('TC3218', 8001, 10000, 18)
insert roysched values('TC3218', 10001, 12000, 20)
insert roysched values('TC3218', 12001, 14000, 22)
insert roysched values('TC3218', 14001, 50000, 24)
insert roysched values('PC8888', 0, 5000, 10)
insert roysched values('PC8888', 5001, 10000, 12)
insert roysched values('PC8888', 10001, 15000, 14)
insert roysched values('PC8888', 15001, 50000, 16)
insert roysched values('PS7777', 0, 5000, 10)
insert roysched values('PS7777', 5001, 50000, 12)
insert roysched values('PS3333', 0, 5000, 10)
insert roysched values('PS3333', 5001, 10000, 12)
insert roysched values('PS3333', 10001, 15000, 14)
insert roysched values('PS3333', 15001, 50000, 16)
insert roysched values('BU1111', 0, 4000, 10)
insert roysched values('BU1111', 4001, 8000, 12)
insert roysched values('BU1111', 8001, 10000, 14)
insert roysched values('BU1111', 12001, 16000, 16)
insert roysched values('BU1111', 16001, 20000, 18)
insert roysched values('BU1111', 20001, 24000, 20)
insert roysched values('BU1111', 24001, 28000, 22)
insert roysched values('BU1111', 28001, 50000, 24)
insert roysched values('MC2222', 0, 2000, 10)
insert roysched values('MC2222', 2001, 4000, 12)
insert roysched values('MC2222', 4001, 8000, 14)
insert roysched values('MC2222', 8001, 12000, 16)
insert roysched values('MC2222', 12001, 20000, 18)
insert roysched values('MC2222', 20001, 50000, 20)
insert roysched values('TC7777', 0, 5000, 10)
insert roysched values('TC7777', 5001, 15000, 12)
insert roysched values('TC7777', 15001, 50000, 14)
insert roysched values('TC4203', 0, 2000, 10)
insert roysched values('TC4203', 2001, 8000, 12)
insert roysched values('TC4203', 8001, 16000, 14)
insert roysched values('TC4203', 16001, 24000, 16)
insert roysched values('TC4203', 24001, 32000, 18)
insert roysched values('TC4203', 32001, 40000, 20)
insert roysched values('TC4203', 40001, 50000, 22)
insert roysched values('BU7832', 0, 5000, 10)
insert roysched values('BU7832', 5001, 10000, 12)
insert roysched values('BU7832', 10001, 15000, 14)
insert roysched values('BU7832', 15001, 20000, 16)
insert roysched values('BU7832', 20001, 25000, 18)
insert roysched values('BU7832', 25001, 30000, 20)
insert roysched values('BU7832', 30001, 35000, 22)
insert roysched values('BU7832', 35001, 50000, 24)
insert roysched values('PS1372', 0, 10000, 10)
insert roysched values('PS1372', 10001, 20000, 12)
insert roysched values('PS1372', 20001, 30000, 14)
insert roysched values('PS1372', 30001, 40000, 16)
insert roysched values('PS1372', 40001, 50000, 18)

insert Discounts values('Initial Customer', NULL, NULL, NULL, 10.5)
insert Discounts values('Volume Discount', NULL, 100, 1000, 6.7)
insert Discounts values('Customer Discount', '8042', NULL, NULL, 5.0)

insert jobs values ('New Hire - Job not specified', 10, 10)
insert jobs values ('Chief Executive Officer', 200, 250)
insert jobs values ('Business Operations Manager', 175, 225)
insert jobs values ('Chief Financial Officier', 175, 250)
insert jobs values ('Publisher', 150, 250)
insert jobs values ('Managing Editor', 140, 225)
insert jobs values ('Marketing Manager', 120, 200)
insert jobs values ('Public Relations Manager', 100, 175)
insert jobs values ('Acquisitions Manager', 75, 175)
insert jobs values ('Productions Manager', 75, 165)
insert jobs values ('Operations Manager', 75, 150)
insert jobs values ('Editor', 25, 100)
insert jobs values ('Sales Representative', 25, 100)
insert jobs values ('Designer', 25, 100)

insert Employees values ('PTC11962M', 'Philip', 'T', 'Cramer', 2, 215, '9952', '11/11/89', '604-232-3232')
insert Employees values ('AMD15433F', 'Ann', 'M', 'Devon', 3, 200, '9952', '07/16/91','604-244-2322')
insert Employees values ('F-C16315M', 'Francisco', '', 'Chang', 4, 227, '9952', '11/03/90','604-244-2322')
insert Employees values ('LAL21447M', 'Laurence', 'A', 'Lebihan', 5, 175, '0736', '06/03/90','604-244-2322')
insert Employees values ('PXH22250M', 'Paul', 'X', 'Henriot', 5, 159, '0877', '08/19/93','604-244-2322')
insert Employees values ('SKO22412M', 'Sven', 'K', 'Ottlieb', 5, 150, '1389', '04/05/91','604-244-2322')
insert Employees values ('RBM23061F', 'Rita', 'B', 'Muller', 5, 198, '1622', '10/09/93','604-244-2322')
insert Employees values ('MJP25939M', 'Maria', 'J', 'Pontes', 5, 246, '1756', '03/01/89','604-244-2322')
insert Employees values ('JYL26161F', 'Janine', 'Y', 'Labrune', 5, 172, '9901', '05/26/91','604-244-2322')
insert Employees values ('CFH28514M', 'Carlos', 'F', 'Hernadez', 5, 211, '9999', '04/21/89','604-244-2322')
insert Employees values ('VPA30890F', 'Victoria', 'P', 'Ashworth', 6, 140, '0877', '09/13/90','604-244-2322')
insert Employees values ('L-B31947F', 'Lesley', '', 'Brown', 7, 120, '0877', '02/13/91','604-244-2322')
insert Employees values ('ARD36773F', 'Anabela', 'R', 'Domingues', 8, 100, '0877', '01/27/93','604-244-2322')
insert Employees values ('M-R38834F', 'Martine', '', 'Rance', 9, 75, '0877', '02/05/92','604-244-2322')
insert Employees values ('PHF38899M', 'Peter', 'H', 'Franken', 10, 75, '0877', '05/17/92','604-244-2322')
insert Employees values ('DBT39435M', 'Daniel', 'B', 'Tonini', 11, 75, '0877', '01/01/90','604-244-2322')
insert Employees values ('H-B39728F', 'Helen', '', 'Bennett', 12, 35, '0877', '09/21/89','604-244-2322')
insert Employees values ('PMA42628M', 'Paolo', 'M', 'Accorti', 13, 35, '0877', '08/27/92','604-244-2322')
insert Employees values ('ENL44273F', 'Elizabeth', 'N', 'Lincoln', 14, 35, '0877', '07/24/90','604-244-2322')
insert Employees values ('MGK44605M', 'Matti', 'G', 'Karttunen', 6, 220, '0736', '05/01/94','604-244-2322')
insert Employees values ('PDI47470M', 'Palle', 'D', 'Ibsen', 7, 195, '0736', '05/09/93','604-244-2322')
insert Employees values ('MMS49649F', 'Mary', 'M', 'Saveley', 8, 175, '0736', '06/29/93','604-244-2322')
insert Employees values ('GHT50241M', 'Gary', 'H', 'Thomas', 9, 170, '0736', '08/09/88','604-244-2322')
insert Employees values ('MFS52347M', 'Martin', 'F', 'Sommer', 10, 165, '0736', '04/13/90','604-244-2322')
insert Employees values ('R-M53550M', 'Roland', '', 'Mendel', 11, 150, '0736', '09/05/91','604-244-2322')
insert Employees values ('HAS54740M', 'Howard', 'A', 'Snyder', 12, 100, '0736', '11/19/88','604-244-2322')
insert Employees values ('TPO55093M', 'Timothy', 'P', 'O''Rourke', 13, 100, '0736', '06/19/88','604-244-2322')
insert Employees values ('KFJ64308F', 'Karin', 'F', 'Josephs', 14, 100, '0736', '10/17/92','604-244-2322')
insert Employees values ('DWR65030M', 'Diego', 'W', 'Roel', 6, 192, '1389', '12/16/91','604-244-2322')
insert Employees values ('M-L67958F', 'Maria', '', 'Larsson', 7, 135, '1389', '03/27/92','604-244-2322')
insert Employees values ('PSP68661F', 'Paula', 'S', 'Parente', 8, 125, '1389', '01/19/94','604-244-2322')
insert Employees values ('MAS70474F', 'Margaret', 'A', 'Smith', 9, 78, '1389', '09/29/88','604-244-2322')
insert Employees values ('A-C71970F', 'Aria', '', 'Cruz', 10, 87, '1389', '10/26/91','604-244-2322')
insert Employees values ('MAP77183M', 'Miguel', 'A', 'Paolino', 11, 112, '1389', '12/07/92','604-244-2322')
insert Employees values ('Y-L77953M', 'Yoshi', '', 'Latimer', 12, 32, '1389', '06/11/89','604-244-2322')
insert Employees values ('CGS88322F', 'Carine', 'G', 'Schmitt', 13, 64, '1389', '07/07/92','604-244-2322')
insert Employees values ('PSA89086M', 'Pedro', 'S', 'Afonso', 14, 89, '1389', '12/24/90','604-244-2322')
insert Employees values ('A-R89858F', 'Annette', '', 'Roulet', 6, 152, '9999', '02/21/90','604-244-2322')
insert Employees values ('HAN90777M', 'Helvetius', 'A', 'Nagy', 7, 120, '9999', '03/19/93','604-244-2322')
insert Employees values ('M-P91209M', 'Manuel', '', 'Pereira', 8, 101, '9999', '01/09/89','604-244-2322')
insert Employees values ('KJJ92907F', 'Karla', 'J', 'Jablonski', 9, 170, '9999', '03/11/94','604-244-2322')
insert Employees values ('POK93028M', 'Pirkko', 'O', 'Koskitalo', 10, 80, '9999', '11/29/93','604-244-2322')
insert Employees values ('PCM98509F', 'Patricia', 'C', 'McKenna', 11, 150, '9999', '08/01/89','604-244-2322')