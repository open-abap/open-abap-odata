import {SQLiteDatabaseClient} from "@abaplint/database-sqlite";

export async function setup(abap, schemas, insert) {
  abap.context.databaseConnections["DEFAULT"] = new SQLiteDatabaseClient();
  await abap.context.databaseConnections["DEFAULT"].connect();
  await abap.context.databaseConnections["DEFAULT"].execute(schemas.sqlite);
  await abap.context.databaseConnections["DEFAULT"].execute(insert);
  await abap.context.databaseConnections["DEFAULT"].execute(
    "INSERT INTO 'zcl_oao_services' ('service_name','dpc_class','mpc_class') VALUES ('ZSEGW_SRV','ZCL_ZSEGW_DPC_EXT','ZCL_ZSEGW_MPC_EXT')"
  );
}