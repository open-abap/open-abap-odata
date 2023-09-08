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

    const expected = `<?xml version="1.0" encoding="utf-8"?>
<edmx:Edmx xmlns:edmx="http://schemas.microsoft.com/ado/2007/06/edmx" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:sap="http://www.sap.com/Protocols/SAPData" Version="1.0">
  <edmx:DataServices m:DataServiceVersion="2.0">
    <Schema xmlns="http://schemas.microsoft.com/ado/2008/09/edm" Namespace="ZSEGW_SRV" xml:lang="en" sap:schema-version="1">
      <Annotation xmlns="http://docs.oasis-open.org/odata/ns/edm" Term="Core.SchemaVersion" String="1.0.0"/>
      <EntityType Name="zsegw" sap:content-version="1">
        <Key>
          <PropertyRef Name="Something1"/>
        </Key>
        <Property Name="Something1" Type="Edm.String" Nullable="false" MaxLength="10" sap:unicode="false" sap:label="SOMETHING1" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>
        <Property Name="Something2" Type="Edm.String" Nullable="false" MaxLength="10" sap:unicode="false" sap:label="SOMETHING2" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>
      </EntityType>
      <EntityContainer Name="ZSEGW_SRV_Entities" m:IsDefaultEntityContainer="true" sap:supported-formats="atom json xlsx">
        <EntitySet Name="zsegwSet" EntityType="ZSEGW_SRV.zsegw" sap:creatable="false" sap:updatable="false" sap:deletable="false" sap:pageable="false" sap:content-version="1"/>
      </EntityContainer>
      <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="self" href="http://localhost:8080/sap/opu/odata/sap/ZSEGW_SRV/$metadata"/>
      <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="latest-version" href="http://localhost:8080/sap/opu/odata/sap/ZSEGW_SRV/$metadata"/>
    </Schema>
  </edmx:DataServices>
</edmx:Edmx>`;

    expect(await res.text()).to.equal(expected);
  });

});