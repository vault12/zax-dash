angular.module("app").run(["$templateCache", function($templateCache) {$templateCache.put("request-pane/request-pane.template.html","<div class=\"request-pane\">\n  <div class=\"request\">\n    <div class=\"row\">\n      <div class=\"col-sm-12\">\n        <div class=\"panel panel-primary\">\n          <div class=\"panel-heading\">\n            <h3 class=\"panel-title\">\n              Mailboxes\n            </h3>\n\n          </div>\n          <div class=\"panel-body\">\n            <table class=\"table\" ng-hide=\"mailboxes | isEmpty\">\n              <thead>\n                <tr>\n                  <th>Name</th>\n                  <th>Secret Key</th>\n                  <th>Public Key</th>\n                  <th>Message Count</th>\n                  <!-- <th>Message Actions</th> -->\n                  <th>Mailbox Actions</th>\n                </tr>\n              </thead>\n              <tr ng-repeat=\"mailbox in mailboxes\" ng-click=\"selectMailbox(mailbox)\" ng-class=\"{info: mailbox == activeMailbox}\">\n                <td>{{mailbox.identity}}</td>\n                <td><div class=\"overflow-box\">{{mailbox.keyRing.comm_key.strSecKey()}}</div></td>\n                <td><div class=\"overflow-box\">{{mailbox.keyRing.comm_key.strPubKey()}}</div></td>\n                <td>\n                  <div class=\"input-group\">\n                    <span class=\"input-group-btn\">\n                      <button\n                        class=\"btn btn-default\"\n                        type=\"button\"\n                        ng-click=\"messageCount(mailbox)\">Get</button>\n                    </span>\n                    <input\n                      type=\"text\"\n                      class=\"form-control\"\n                      ng-model=\"mailbox.messageCount\"\n                      placeholder=\"???\">\n                  </div>\n                </td>\n                <td>\n                  <button class=\"btn btn-default btn-danger\" ng-click=\"deleteMailbox(mailbox)\">Self Destruct</button>\n                </td>\n              </tr>\n            </table>\n              <div class=\"row\">\n                <div class=\"col-sm-8\" ng-hide=\"mailboxes | isEmpty\">\n                  <div class=\"panel panel-info\">\n                    <div class=\"panel-heading\">\n                      <h3 class=\"panel-title\" ng-hide=\"!activeMailbox\">{{activeMailbox.messageCount || \"???\"}} messages for {{activeMailbox.identity}}</h3>\n                      <h3 class=\"panel-title\" ng-hide=\"activeMailbox\">select a mailbox</h3>\n                    </div>\n                    <div class=\"panel-body\" ng-hide=\"!activeMailbox\">\n                      <div class=\"row\">\n                        <div class=\"col-sm-12\">\n                          <h3>Messages</h3>\n                          <table class=\"table table-striped\">\n                            <thead>\n                              <tr>\n                                <th class=\"col-md-2\">from</th>\n                                <th class=\"col-md-2\">nonce</th>\n                                <th class=\"col-md-2\">time</th>\n                                <th class=\"col-md-3\">message</th>\n                                <th class=\"col-md-3\"></th>\n                              </tr>\n                            </thead>\n                            <tr ng-repeat=\"message in activeMailbox.messages\">\n                              <td class=\"col-md-2\"><div class=\"overflow-box\" ng-click=\"selectText(e)\">{{message.fromTag || message.from}}</div></td>\n                              <td class=\"col-md-2\"><div class=\"overflow-box\">{{message.nonce}}</div></td>\n                              <td class=\"col-md-2\"><div class=\"overflow-box\" >{{message.time * 1000 | date:\'short\'}}</div></td>\n                              <td class=\"col-md-3\"><div class=\"overflow-wrap\">{{message.msg || message.data}}</div></td>\n                              <td class=\"col-md-3\">\n                                <button class=\"btn btn-mini btn-danger\" ng-click=\"deleteMessages(activeMailbox, [message.nonce])\">\n                                  <i class=\"glyphicon glyphicon-remove\" ></i> Delete\n                                </button>\n                              </td>\n                            </tr>\n                            <!-- <tr>\n                              <td colspan=\"5\">\n\n                              </td>\n                            </tr> -->\n                          </table>\n                          <span class=\"input-group-btn\">\n                            <button\n                              class=\"btn btn-default\"\n                              type=\"button\"\n                              ng-click=\"getMessages(activeMailbox)\">Fetch All</button>\n                            <button\n                              class=\"btn btn-default\"\n                              type=\"button\"\n                              ng-click=\"deleteMessages(activeMailbox)\">Delete All</button>\n                          </span>\n                        </div>\n                      </div>\n                      <div class=\"row\">\n                        <div class=\"col-sm-12\">\n                          <h3>Send Message</h3>\n                          <div class=\"input-group\">\n                            <span class=\"input-group-btn\">\n                              <input type=\"text\" ng-model=\"outgoing.message\" placeholder=\"message\" class=\"form-control\">\n                            </span>\n                            <span class=\"input-group-btn\">\n                              <select type=\"text\" ng-model=\"outgoing.recipient\" class=\"form-control\">\n                                <option value=\"\" disabled selected>recipient</option>\n                                <option ng-repeat=\"mailbox in mailboxes\" value=\"{{mailbox.identity}}\">{{mailbox.identity}}</option>\n                              </select>\n                            </span>\n                            <span class=\"input-group-btn\">\n                              <button\n                                class=\"btn btn-success\"\n                                type=\"button\"\n                                ng-click=\"sendMessage(activeMailbox, outgoing)\">Send</button>\n                            </span>\n                          </div>\n                        </div>\n                      </div>\n                    </div>\n                  </div>\n                </div>\n                <div class=\"col-sm-4\">\n                  <div class=\"panel panel-warning\">\n                    <div class=\"panel-heading\">\n                      <h3 class=\"panel-title\">Add Mailbox</h3>\n                    </div>\n                    <div class=\"panel-body\">\n                      <label for=\"name\" >Name</label>\n                      <div class=\"input-group\">\n\n                        <input type=\"text\" id=\"name\" ng-model=\"newMailbox.name\" placeholde`r=\"name\" class=\"form-control\">\n                        <span class=\"input-group-btn\">\n                          <button class=\"btn btn-default pull-right\" ng-click=\"addMailbox(newMailbox.name)\">Add</button>\n                        </span>\n                      </div><br/>\n                      <label ng-hide=\"!newMailbox.name\">From Seed</label>\n                      <div class=\"input-group\" ng-hide=\"!newMailbox.name\">\n                        <input\n                          type=\"text\"\n                          id=\"seed\"\n                          ng-model=\"newMailbox.seed\"\n                          placeholder=\"seed\"\n                          class=\"form-control\">\n                        <span class=\"input-group-btn\">\n                          <button class=\"btn btn-default pull-right\" ng-click=\"addMailbox(newMailbox.name, {seed:newMailbox.seed})\">Add</button>\n                        </span>\n                      </div><br/>\n\n                      <label ng-hide=\"!newMailbox.name\">From Secret</label>\n                      <div class=\"input-group\" ng-hide=\"!newMailbox.name\">\n                        <input\n                          type=\"text\"\n                          id=\"seed\"\n                          ng-model=\"newMailbox.secret\"\n                          placeholder=\"secret\"\n                          class=\"form-control\">\n                        <span class=\"input-group-btn\">\n                          <button class=\"btn btn-default pull-right\" ng-click=\"addMailbox(newMailbox.name, {secret:newMailbox.secret})\">Add</button>\n                        </span>\n                      </div>\n                      <hr />\n                      <form class=\"form\">\n                        <div class=\"input-group\">\n                          <input\n                            type=\"text\"\n                            class=\"form-control\"\n                            ng-model=\"quantity\">\n                          <span class=\"input-group-btn\">\n                            <button\n                              class=\"btn btn-default\"\n                              type=\"button\"\n                              ng-click=\"addMailboxes(quantity)\">Create Multiple Mailboxes</button>\n                          </span>\n                        </div>\n                      </form>\n                    </div>\n                  </div>\n                </div>\n              </div>\n            </div>\n          </div>\n        </div>\n\n      </div>\n    </div>\n    <!--  mailbox selector-->\n\n\n  </div>\n</div>\n");}]);