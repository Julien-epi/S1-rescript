// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core__Promise from "@rescript/core/src/Core__Promise.res.mjs";
import * as Webapi__Fetch from "rescript-webapi/src/Webapi/Webapi__Fetch.res.mjs";

function get(domainUrl, headers) {
  return async function (path, parser) {
    return await Core__Promise.$$catch(fetch(domainUrl.concat(path), Webapi__Fetch.RequestInit.make("Get", Caml_option.some(headers), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)).then(function (prim) {
                      return prim.text();
                    }).then(function (res) {
                    var parsedData = parser(res);
                    if (parsedData.TAG === "Ok") {
                      return Promise.resolve({
                                  TAG: "Ok",
                                  _0: parsedData._0
                                });
                    } else {
                      return Promise.resolve({
                                  TAG: "Error",
                                  _0: parsedData._0
                                });
                    }
                  }), (function (param) {
                  return Promise.resolve({
                              TAG: "Error",
                              _0: "Network error"
                            });
                }));
  };
}

function create(domainUrl, headers) {
  return async function (path, body) {
    return await Core__Promise.$$catch(fetch(domainUrl.concat(path), Webapi__Fetch.RequestInit.make("Post", Caml_option.some(headers), Caml_option.some(JSON.stringify(body)), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)).then(function (prim) {
                      return prim.text();
                    }).then(function (res) {
                    return Promise.resolve({
                                TAG: "Ok",
                                _0: res
                              });
                  }), (function (param) {
                  return Promise.resolve({
                              TAG: "Error",
                              _0: "Network error"
                            });
                }));
  };
}

function update(domainUrl, headers) {
  return async function (path, body) {
    return await Core__Promise.$$catch(fetch(domainUrl.concat(path), Webapi__Fetch.RequestInit.make("Put", Caml_option.some(headers), Caml_option.some(JSON.stringify(body)), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)).then(function (prim) {
                      return prim.text();
                    }).then(function (res) {
                    return Promise.resolve({
                                TAG: "Ok",
                                _0: res
                              });
                  }), (function (param) {
                  return Promise.resolve({
                              TAG: "Error",
                              _0: "Network error"
                            });
                }));
  };
}

function delete_(domainUrl, headers) {
  return async function (path) {
    return await Core__Promise.$$catch(fetch(domainUrl.concat(path), Webapi__Fetch.RequestInit.make("Delete", Caml_option.some(headers), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)).then(function (prim) {
                      return prim.text();
                    }).then(function (res) {
                    return Promise.resolve({
                                TAG: "Ok",
                                _0: res
                              });
                  }), (function (param) {
                  return Promise.resolve({
                              TAG: "Error",
                              _0: "Network error"
                            });
                }));
  };
}

export {
  get ,
  create ,
  update ,
  delete_ ,
}
/* No side effect */
