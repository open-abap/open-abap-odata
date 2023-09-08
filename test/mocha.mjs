import {expect} from 'chai';
import {startServer} from './start.mjs';

describe('Integration Test', async () => {
  let server;

  before(async () => {
    server = await startServer(true);
  });

  after(async () => {
    server.close();
  });

  it('404, not found', async () => {
    const res = await fetch('http://localhost:3030/hello');
    expect(res.status).to.equal(404);
  });

});