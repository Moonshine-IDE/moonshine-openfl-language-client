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

package moonshine.lsp;

import moonshine.lsp.WorkspaceFolder;
import moonshine.lsp.WorkDoneProgressParams;

/**
	Implementation of `InitializeParams` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.

	@see https://microsoft.github.io/language-server-protocol/specification#initialize
**/
typedef InitializeParams = {
	> WorkDoneProgressParams,

	/**
		The process Id of the parent process that started the server. Is null if
		the process has not been started by another process. If the parent
		process is not alive then the server should exit (see exit notification)
		its process.
	**/
	processId:Null<Int>,

	/**
		Information about the client
	**/
	?clientInfo:Null<{name:String, ?version:String}>,
	/**
		The locale the client is currently showing the user interface
		in. This must not necessarily be the locale of the operating
		system.

		Uses [IETF language tags](https://en.wikipedia.org/wiki/IETF_language_tag) as the value's syntax
	**/
	?locale:String,
	/**
		The root path of the workspace. Is null if no folder is open.

		Deprecated in favour of `rootUri`.
	**/
	?rootPath:String,

	/**
		The rootUri of the workspace. Is null if no folder is open. If both
		`rootPath` and `rootUri` are set `rootUri` wins.

		Deprecated in favour of `workspaceFolders`
	**/
	rootUri:Null<String>,

	/**
		User provided initialization options.
	**/
	?initializationOptions:Any,

	/**
		The capabilities provided by the client (editor or tool)
	**/
	capabilities:ClientCapabilities,

	/**
		The initial trace setting. If omitted, trace is disabled ('off').
	**/
	?trace:TraceValue,
	/**
		The workspace folders configured in the client when the server starts.
		This property is only available if the client supports workspace
		folders. It can be `null` if the client supports workspace folders but
		none are configured.
	**/
	?workspaceFolders:Array<WorkspaceFolder>,
}
