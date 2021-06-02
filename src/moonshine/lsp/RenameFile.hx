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

/**
	Implementation of `RenameFile` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#file-resource-changes
**/
class RenameFile {
	public static final KIND:String = "rename";

	/**
		The kind of file operation.
	**/
	public final kind:String = KIND;

	/**
		The old (existing) location.
	**/
	public var oldUri:String;

	/**
		The new location.
	**/
	public var newUri:String;

	public function new(oldUri:String = null, newUri:String = null) {
		this.oldUri = oldUri;
		this.newUri = newUri;
	}

	public static function parse(original:Dynamic):RenameFile {
		var vo = new RenameFile();
		vo.oldUri = original.oldUri;
		vo.newUri = original.newUri;
		return vo;
	}
}
