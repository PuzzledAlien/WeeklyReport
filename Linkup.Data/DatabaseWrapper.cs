using Linkup.Common;
using Linkup.DataRelationalMapping;
using Dapper;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace Linkup.Data
{
    /*
     * 配合 Linkup.DataRelationalMapping 对数据库进行操作
     *
     */

    public class DatabaseWrapper
    {
        private readonly string _connectionString;
        private readonly LogService _log = LogService.Instance;
        private readonly ExceptionHandlingService _exceptionHandling = ExceptionHandlingService.Instance;

        /// <summary>
        /// 用配置文件中 DefaultConnection 创建数据库连接
        /// </summary>
        public DatabaseWrapper()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        }

        public DatabaseWrapper(string connectionStringConfig)
        {
            _connectionString = ConfigurationManager.ConnectionStrings[connectionStringConfig].ConnectionString;
        }

        private Microsoft.Data.SqlClient.SqlConnection CreateConnection()
        {
            return new Microsoft.Data.SqlClient.SqlConnection(_connectionString);
        }

        /// <summary>
        ///  int affectedRowCount
        /// </summary>
        /// <param name="commandText"></param>
        /// <returns></returns>
        public int ExecuteNonQuery(string commandText)
        {
            return ExecuteNonQuery(CommandType.Text, commandText, null);
        }

        public int ExecuteNonQuery(string commandText, List<CommandParameter> parameterList)
        {
            return ExecuteNonQuery(CommandType.Text, commandText, parameterList);
        }

        public int ExecuteNonQuery(CommandType commandType, string commandText)
        {
            return ExecuteNonQuery(commandType, commandText, null);
        }

        public int ExecuteNonQuery(CommandType commandType, string commandText, List<CommandParameter> parameterList)
        {
            try
            {
                using var connection = CreateConnection();
                var parameters = ConvertToDynamicParameters(parameterList);
                return connection.Execute(commandText, parameters, commandType: commandType == CommandType.StoredProcedure ? CommandType.StoredProcedure : CommandType.Text);
            }
            catch (Exception exception)
            {
                return HandleException(commandText, parameterList, exception);
            }
        }

        public object ExecuteScalar(string commandText)
        {
            return ExecuteScalar(CommandType.Text, commandText, null);
        }

        public bool ExecuteScalar<T>(string commandText, Action<T> callback)
        {
            return ExecuteScalar<T>(CommandType.Text, commandText, null, callback);
        }

        public object ExecuteScalar(string commandText, List<CommandParameter> parameterList)
        {
            return ExecuteScalar(CommandType.Text, commandText, parameterList);
        }

        public bool ExecuteScalar<T>(string commandText, List<CommandParameter> parameterList, Action<T> callback)
        {
            return ExecuteScalar<T>(CommandType.Text, commandText, parameterList, callback);
        }

        public object ExecuteScalar(CommandType commandType, string commandText, List<CommandParameter> parameterList)
        {
            try
            {
                using var connection = CreateConnection();
                var parameters = ConvertToDynamicParameters(parameterList);
                return connection.ExecuteScalar(commandText, parameters, commandType: commandType == CommandType.StoredProcedure ? CommandType.StoredProcedure : CommandType.Text);
            }
            catch (Exception exception)
            {
                return HandleException(commandText, parameterList, exception);
            }
        }

        public bool ExecuteScalar<T>(CommandType commandType, string commandText, List<CommandParameter> parameterList,
            Action<T> callback)
        {
            object scalarValue = ExecuteScalar(commandType, commandText, parameterList);
            if (scalarValue == null || scalarValue == DBNull.Value)
                return false;
            else
            {
                if (scalarValue.GetType() == typeof(byte) && typeof(T) == typeof(int))
                {
                    scalarValue = Convert.ToInt32(scalarValue);
                }
                else if (typeof(T) == typeof(int))
                {
                    scalarValue = Convert.ToInt32(scalarValue);
                }

                callback((T)scalarValue);
                return true;
            }
        }

        public DataSet ExecuteDataSet(string commandText)
        {
            return ExecuteDataSet(CommandType.Text, commandText, new[] { "Table" });
        }

        public DataSet ExecuteDataSet(string commandText, string[] tableNameArray)
        {
            return ExecuteDataSet(CommandType.Text, commandText, tableNameArray);
        }

        public DataSet ExecuteDataSet(CommandType commandType, string commandText, string[] tableNameArray)
        {
            return ExecuteDataSet(CommandType.Text, commandText, null, tableNameArray);
        }

        public DataSet ExecuteDataSet(string commandText,
           List<CommandParameter> parameterList, string[] tableNameArray)
        {
            return ExecuteDataSet(CommandType.Text, commandText, parameterList, tableNameArray);
        }

        public DataSet ExecuteDataSet(CommandType commandType, string commandText,
            List<CommandParameter> parameterList, string[] tableNameArray)
        {
            try
            {
                using var connection = CreateConnection();
                var parameters = ConvertToDynamicParameters(parameterList);

                var reader = connection.ExecuteReader(commandText, parameters, commandType: commandType == CommandType.StoredProcedure ? CommandType.StoredProcedure : CommandType.Text);
                var ds = new DataSet();
                ds.Tables.Add(ConvertToDataTable(reader, tableNameArray?.FirstOrDefault() ?? "Table"));
                return ds;
            }
            catch (Exception exception)
            {
                HandleException(commandText, parameterList, exception);
                return null;
            }
        }

        /// <summary>
        /// 返回受影响的行数
        /// </summary>
        /// <param name="sqlExpression"></param>
        public int ExcuteSqlExpression(SqlExpression sqlExpression)
        {
            int affectedRowCount = 0;
            Microsoft.Data.SqlClient.SqlConnection connection = null;
            try
            {
                connection = CreateConnection();
                connection.Open();
                var parameters = ConvertToDynamicParametersFromSqlParameters(sqlExpression.ParameterList);
                affectedRowCount = connection.Execute(sqlExpression.Sql, parameters);
            }
            catch (Exception exception)
            {
                HandleException(sqlExpression.ToString(), null, exception);
            }
            finally
            {
                connection?.Close();
                connection?.Dispose();
            }

            return affectedRowCount;
        }

        public void ExcuteSqlExpression(List<SqlExpression> sqlExpressionList)
        {
            Microsoft.Data.SqlClient.SqlConnection connection = null;
            Microsoft.Data.SqlClient.SqlTransaction transaction = null;
            try
            {
                connection = CreateConnection();
                connection.Open();
                transaction = connection.BeginTransaction();

                foreach (var item in sqlExpressionList)
                {
                    try
                    {
                        var parameters = ConvertToDynamicParametersFromSqlParameters(item.ParameterList);
                        connection.Execute(item.Sql, parameters, transaction: transaction);
                    }
                    catch (Exception exception)
                    {
                        transaction?.Rollback();
                        HandleException(item.ToString(), null, exception);
                    }
                }

                transaction?.Commit();
            }
            catch (Exception exception)
            {
                transaction?.Rollback();
                HandleException(null, null, exception);
            }
            finally
            {
                connection?.Close();
                connection?.Dispose();
            }
        }

        private DataSet ExcuteDataSetSqlExpression(SqlExpression sqlExpression)
        {
            return ExecuteDataSet(CommandType.Text, sqlExpression.Sql,
                GetCommandParameterList(sqlExpression.ParameterList), new string[] { "Table" });
        }

        private List<CommandParameter> GetCommandParameterList(List<System.Data.SqlClient.SqlParameter> list)
        {
            List<CommandParameter> resultList = new List<CommandParameter>();

            if (list != null)
            {
                foreach (var item in list)
                {
                    CommandParameter cmd = new CommandParameter();
                    cmd.ParameterName = item.ParameterName;
                    cmd.Value = item.Value;

                    resultList.Add(cmd);
                }
            }

            return resultList;
        }

        /// <summary>
        /// 填充一个对象，根据对象上有keyAttribute的属性生成where
        /// 如果取出的数据集不是唯一的一条记录，则无法填充
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="obj"></param>
        public bool Fill<T>(object obj) where T : class, new()
        {
            return Fill<T>(obj, null, null);
        }

        public bool Fill<T>(object obj, Dictionary<string, object> attachedWhere) where T : class, new()
        {
            return Fill<T>(obj, null, null);
        }

        public bool Fill<T>(object obj, string table) where T : class, new()
        {
            return Fill<T>(obj, table, null);
        }

        public bool Fill<T>(object obj, string table, Dictionary<string, object> attachedWhere) where T : class, new()
        {
            SqlExpressionArgs args = new SqlExpressionArgs();
            args.Table = table;
            args.Type = SqlExpressionType.Select;
            if (attachedWhere == null)
            {
                args.GenerateWhere = true;
            }
            else
            {
                args.GenerateWhere = false;
                args.AttachedWhere = AttachedWhereItem.Parse(attachedWhere);
            }

            SqlExpression sqlExpression = RelationalMappingUnity.GetSqlExpression(obj, args);

            DataSet ds = ExcuteDataSetSqlExpression(sqlExpression);
            List<T> dataList = RelationalMappingUnity.Select<T>(ds.Tables[0]);

            Debug.Assert(dataList.Count <= 1, "Fill 时取出的记录大于1条");

            if (dataList.Count != 1)
            {
                return false;
            }

            T dataObj = dataList[0];

            ReflectionHelper.Inject(obj, dataObj);

            return true;
        }


        public List<T> Select<T>() where T : class, new()
        {
            return Select<T>(new Dictionary<string, object>(), null);
        }

        public List<T> Select<T>(Dictionary<string, object> attachedWhere) where T : class, new()
        {
            return Select<T>(AttachedWhereItem.Parse(attachedWhere), null);
        }

        public List<T> Select<T>(Dictionary<string, object> attachedWhere, SqlExpressionPagingArgs pagingArgs) where T : class, new()
        {
            return Select<T>(AttachedWhereItem.Parse(attachedWhere), pagingArgs);
        }

        public List<T> Select<T>(List<AttachedWhereItem> attachedWhere) where T : class, new()
        {
            return Select<T>(attachedWhere, null);
        }

        public List<T> Select<T>(SqlExpressionPagingArgs pagingArgs) where T : class, new()
        {
            return Select<T>(new List<AttachedWhereItem>(), pagingArgs);
        }

        public List<T> Select<T>(List<AttachedWhereItem> attachedWhere, SqlExpressionPagingArgs pagingArgs) where T : class, new()
        {
            SqlExpressionArgs args = new SqlExpressionArgs();
            args.Type = SqlExpressionType.Select;
            args.GenerateWhere = false;
            args.AttachedWhere = attachedWhere;
            args.PagingArgs = pagingArgs;

            SqlExpression sqlExpression = RelationalMappingUnity.GetSqlExpression(new T(), args);

            DataSet ds = ExcuteDataSetSqlExpression(sqlExpression);
            List<T> dataList = RelationalMappingUnity.Select<T>(ds.Tables[0]);

            if (pagingArgs != null)
            {
                if (ds.Tables.Count > 1)
                {
                    pagingArgs.TotalRow = int.Parse(ds.Tables[1].Rows[0][0].ToString());
                }
                else
                {
                    pagingArgs.TotalRow = ds.Tables[0].Rows.Count;
                }
                pagingArgs.TotalPage = pagingArgs.TotalRow / pagingArgs.PageSize;
                if (pagingArgs.TotalRow % pagingArgs.PageSize > 0)
                    pagingArgs.TotalPage++;
            }

            return dataList;
        }

        public List<T> Select<T>(string sql) where T : class
        {
            DataSet ds = ExecuteDataSet(sql);
            List<T> dataList = RelationalMappingUnity.Select<T>(ds.Tables[0]);
            return dataList;
        }

        public List<T> Select<T>(string sql, List<CommandParameter> parameterList) where T : class
        {
            DataSet ds = ExecuteDataSet(sql, parameterList, new string[] { "Table" });
            List<T> dataList = RelationalMappingUnity.Select<T>(ds.Tables[0]);
            return dataList;
        }

        /// <summary>
        /// 插入失败以异常形式抛出
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public bool Insert(object obj)
        {
            if (obj == null)
                return false;

            SqlExpressionArgs args = new SqlExpressionArgs();
            args.Type = SqlExpressionType.Insert;
            SqlExpression sqlExpression = RelationalMappingUnity.GetSqlExpression(obj, args);
            return ExcuteSqlExpression(sqlExpression) == 1;
        }

        /// <summary>
        /// 封装为一个事务进行写入
        /// </summary>
        /// <param name="obj1"></param>
        /// <param name="obj2"></param>
        /// <param name="obj"></param>
        public void InsertList(object obj1, object obj2, params object[] obj)
        {
            List<object> objList = new List<object>();
            objList.Add(obj1);
            objList.Add(obj2);
            if (obj != null && obj.Length > 0)
            {
                foreach (var item in obj)
                {
                    objList.Add(item);
                }
            }
            InsertList(objList);
        }

        /// <summary>
        /// 封装为一个事务进行写入
        /// </summary>
        /// <param name="objList"></param>
        public void InsertList(List<object> objList)
        {
            if (objList == null)
                return;

            List<SqlExpression> sqlExpressionList = new List<SqlExpression>();

            SqlExpressionArgs args = new SqlExpressionArgs();
            args.Type = SqlExpressionType.Insert;

            foreach (var item in objList)
            {
                if (item == null)
                {
                    Debug.Assert(false, "insert obj 为 null");
                    continue;
                }

                SqlExpression sqlExpression = RelationalMappingUnity.GetSqlExpression(item, args);
                sqlExpressionList.Add(sqlExpression);
            }

            ExcuteSqlExpression(sqlExpressionList);
        }

        public int Update(object obj)
        {
            return Update(obj, null);
        }

        public int Update(object obj, string table)
        {
            return Update(obj, table, null);
        }

        public int Update(object obj, string table, string excludeFields)
        {
            if (obj == null)
                return 0;

            SqlExpressionArgs args = new SqlExpressionArgs();
            args.Table = table;
            args.Type = SqlExpressionType.Update;
            args.ExcludeFields = excludeFields;
            SqlExpression sqlExpression = RelationalMappingUnity.GetSqlExpression(obj, args);
            return ExcuteSqlExpression(sqlExpression);
        }

        public void UpdateList(object obj1, object obj2, params object[] obj)
        {
            List<object> objList = new List<object>();
            objList.Add(obj1);
            objList.Add(obj2);
            if (obj != null && obj.Length > 0)
            {
                foreach (var item in obj)
                {
                    objList.Add(item);
                }
            }
            UpdateList(objList);
        }

        public void UpdateList(List<object> objList)
        {
            if (objList == null)
                return;

            List<SqlExpression> sqlExpressionList = new List<SqlExpression>();

            SqlExpressionArgs args = new SqlExpressionArgs();
            args.Type = SqlExpressionType.Update;

            foreach (var item in objList)
            {
                if (item == null)
                {
                    Debug.Assert(false, "insert obj 为 null");
                    continue;
                }

                SqlExpression sqlExpression = RelationalMappingUnity.GetSqlExpression(item, args);
                sqlExpressionList.Add(sqlExpression);
            }

            ExcuteSqlExpression(sqlExpressionList);
        }

        public int Remove(object obj)
        {
            if (obj == null)
                return 0;

            SqlExpressionArgs args = new SqlExpressionArgs();
            args.Type = SqlExpressionType.Delete;
            SqlExpression sqlExpression = RelationalMappingUnity.GetSqlExpression(obj, args);
            return ExcuteSqlExpression(sqlExpression);
        }

        public List<System.Data.SqlClient.SqlParameter> CommandParameterToSqlParameter(List<CommandParameter> parameterList)
        {
            List<System.Data.SqlClient.SqlParameter> list = new List<System.Data.SqlClient.SqlParameter>();

            if (parameterList == null || parameterList.Count == 0)
                return list;

            foreach (var item in parameterList)
            {
                System.Data.SqlClient.SqlParameter sqlParameter = new System.Data.SqlClient.SqlParameter(item.ParameterName, item.Value);
                list.Add(sqlParameter);
            }

            return list;
        }

        private DynamicParameters ConvertToDynamicParameters(List<CommandParameter> parameterList)
        {
            var parameters = new DynamicParameters();
            if (parameterList != null && parameterList.Count > 0)
            {
                foreach (var param in parameterList)
                {
                    parameters.Add(param.ParameterName, param.Value);
                }
            }
            return parameters;
        }

        private DynamicParameters ConvertToDynamicParametersFromSqlParameters(List<System.Data.SqlClient.SqlParameter> parameterList)
        {
            var parameters = new DynamicParameters();
            if (parameterList != null && parameterList.Count > 0)
            {
                foreach (var param in parameterList)
                {
                    parameters.Add(param.ParameterName, param.Value);
                }
            }
            return parameters;
        }

        private DataTable ConvertToDataTable(IDataReader reader, string tableName)
        {
            var dataTable = new DataTable(tableName);
            dataTable.Load(reader);
            return dataTable;
        }

        private int HandleException(string commandText, List<CommandParameter> parameterList, Exception exception)
        {
            string logMessage = commandText;
            if (parameterList != null)
            {
                logMessage += Environment.NewLine + JsonHelper.Serializer(parameterList);
            }
            logMessage += Environment.NewLine + exception.StackTrace;
            _log.Write(exception.Message, logMessage, TraceEventType.Error);

            Exception exceptionToThrow;
            _exceptionHandling.HandleException(exception, out exceptionToThrow);
            throw exceptionToThrow;
        }

    }
}