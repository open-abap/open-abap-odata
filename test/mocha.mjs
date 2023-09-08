import {expect} from 'chai';
import {startServer} from './start.mjs';

describe('Integration Test', async () => {
  let server;

  before(async () => {
    server = startServer(true);
  });

  after(async () => {
    server.close();
  });

  it('404, not found', async () => {
    const res = await fetch('http://localhost:3030/hello');
    expect(res.status).to.equal(404);
  });

  it('get metadata', async () => {
    const res = await fetch('http://localhost:3030/sap/opu/odata/sap/ZSEGW_SRV/$metadata');
    expect(res.status).to.equal(200);
    expect(await res.text()).to.contain(`<?xml version="1.0" encoding="utf-8"?>`);
  });

});