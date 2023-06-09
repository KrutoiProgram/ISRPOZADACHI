
/****** Object:  Table [dbo].[Job]    Script Date: 29.03.2023 13:59:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Job](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Surname] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Birthday] [datetime] NULL,
	[Adress] [nvarchar](100) NULL,
	[PasportID] [int] NULL,
	[Email] [nvarchar](50) NULL,
	[JobCategory] [int] NULL,
 CONSTRAINT [PK_Job] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobName]    Script Date: 29.03.2023 13:59:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobName](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[JobName] [nvarchar](50) NULL,
	[Salary] [money] NULL,
 CONSTRAINT [PK_JobName] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Job]  WITH CHECK ADD  CONSTRAINT [FK_Job_JobName] FOREIGN KEY([JobCategory])
REFERENCES [dbo].[JobName] ([ID])
GO
ALTER TABLE [dbo].[Job] CHECK CONSTRAINT [FK_Job_JobName]
GO