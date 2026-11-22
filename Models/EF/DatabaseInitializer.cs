using System.Data.Entity;

namespace Models.EF
{
    public class DatabaseInitializer : CreateDatabaseIfNotExists<DBNoiThat>
    {
        protected override void Seed(DBNoiThat context)
        {
            context.Database.ExecuteSqlCommand(
                "IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Avatar' AND Object_ID = OBJECT_ID(N'[User]')) " +
                "ALTER TABLE [User] ADD Avatar NVARCHAR(255) NULL;"
            );
            base.Seed(context);
        }
    }
}
