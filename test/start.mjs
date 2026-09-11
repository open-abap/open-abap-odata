import express from 'express';
import {initializeABAP} from "../output/init.mjs";
import {cl_express_icf_shim} from "../output/cl_express_icf_shim.clas.mjs";
import {zcl_oao_registry} from "../output/zcl_oao_registry.clas.mjs";

await initializeABAP();

// service name -> MPC/DPC classes; on a real system this is the SEGW registration
await zcl_oao_registry.register({
  iv_service: new abap.types.String().set("ZSEGW_SRV"),
  iv_mpc: new abap.types.String().set("ZCL_ZSEGW_MPC_EXT"),
  iv_dpc: new abap.types.String().set("ZCL_ZSEGW_DPC_EXT"),
});

export function startServer(quiet) {
  const PORT = 3030;

  const app = express();
  app.disable('x-powered-by');
  app.set('etag', false);
  app.use(express.raw({type: "*/*"}));

// ------------------

  app.get('/', function (req, res) {
    res.send('path: /');
  });

// ------------------

  app.all("/sap/opu/odata/sap/*", async function (req, res) {
    await cl_express_icf_shim.run({
      req,
      res,
      class: "/IWFND/CL_SODATA_HTTP_HANDLER",
      base: new abap.types.String().set("/ztestabap")
    });
  });

  const server = app.listen(PORT);
  if (quiet !== true) {
    console.log("Listening on port http://localhost:" + PORT + "/ztestabap");
  }

  return server;
}