using System;
using System.Data;
using X.Data;

namespace Repositories
{
    public static class SampleRepository
    {
        public static DataSet SampleDataGet()
        {
            DataSet data = new DataSet();
            DataTable dataTable = new DataTable();

            data.Tables.Add(dataTable);

            dataTable.Columns.Add("FirstName", typeof(String));
            dataTable.Columns.Add("LastName", typeof(String));
            dataTable.Columns.Add("Title", typeof(String));
            
            for (int i = 0; i < 4; i++)
            {
                dataTable.Rows.Add("Abc", "Efg", "Tester");
                dataTable.Rows.Add("Xyz", "Opq", "Tester");
            }
            return data;
            /*
             * return SqlHelper.ExecuteDataset(
                     "dbo.XYZ_Get"
                     );
             */
        }
    }
}