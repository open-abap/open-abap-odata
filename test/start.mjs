import express from 'express';
import {initializeABAP} from "../output/init.mjs";
import {cl_express_icf_shim} from "../output/cl_express_icf_shim.clas.mjs";

await initializeABAP();

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

  app.all("/ztestabap*", async function (req, res) {
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