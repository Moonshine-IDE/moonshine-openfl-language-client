/*
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License

	No warranty of merchantability or fitness of any kind.
	Use this software at your own risk.
 */

package moonshine.lsp.events;

import openfl.events.EventType;
import openfl.events.Event;

class LspNotificationEvent<T> extends Event {
	public static final LOG_MESSAGE:EventType<LspNotificationEvent<LogMessageParams>> = "logMessage";
	public static final SHOW_MESSAGE:EventType<LspNotificationEvent<ShowMessageParams>> = "showMessage";
	public static final REGISTER_CAPABILITY:EventType<LspNotificationEvent<RegistrationParams>> = "registerCapability";
	public static final UNREGISTER_CAPABILITY:EventType<LspNotificationEvent<RegistrationParams>> = "unregisterCapability";
	public static final APPLY_EDIT:EventType<LspNotificationEvent<WorkspaceEdit>> = "applyEdit";
	public static final PROGRESS:EventType<LspNotificationEvent<ProgressParams>> = "progress";
	public static final PUBLISH_DIAGNOSTICS:EventType<LspNotificationEvent<Map<String, Array<Diagnostic>>>> = "publishDiagnostics";

	public function new(type:EventType<LspNotificationEvent<T>>, params:T) {
		super(type);
		this.params = params;
	}

	public var params:T;

	override public function clone():Event {
		return new LspNotificationEvent(this.type, this.params);
	}
}
