# open-abap-odata

OData shims for Node.js and Steampunk

Run locally with NodeJS 16+, `npm install && npm test`

Scaffolding of `IF_HTTP_EXTENSION` and `IF_HTTP_SERVICE_EXTENSION` must be implemented separately on the target system by calling `ZCL_OAO_HTTP_HANDLER` methods.

Services are registered by name before the first request, the same way SEGW registration does it on a real system:

```abap
zcl_oao_registry=>register(
  iv_service = 'ZSEGW_SRV'
  iv_mpc     = 'ZCL_ZSEGW_MPC_EXT'
  iv_dpc     = 'ZCL_ZSEGW_DPC_EXT' ).
```

`ZCL_OAO_HTTP_HANDLER` resolves `/sap/opu/odata/sap/<service>/...` through the registry and instantiates the classes dynamically, so the shim can be consumed as a transpiler lib without any concrete service class in it. See `test/start.mjs` for the Node.js side of the registration.

![Overview](overview.drawio.svg)
