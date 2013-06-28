/*! jQuery klass v0.2a - Jean-Louis Grall - MIT license - http://code.google.com/p/jquery-klass-plugin */

( function( $, undefined ) {


// Function: $.klass( [SuperKlass,] props )
// Creates and returns a new class.
// Usages:  MyKlass = $.klass( { init: function() { ... } } )
// 			MyKlass = $.klass( SuperKlass, { } )
// Arguments:
// 		SuperKlass	(optional) The super class that the new class will extend.
// 		props		Set of methods and other class properties.
// Special props names:
// 		init		The constructor. If omitted, an implicit init will be created.
// 					Thus all classes have an init method.
// 		_klass		Set of class methods (static methods). They will be added directly to the class.
// Notes:
// 	- $.klass is the implicit super class, not Object
    var $klass = $.klass = function( _super, fields ) {	// The class factory. It is also the invisible "super class" of all classes. Methods added to its prototype will be available to all classes.

            // If no _super:
            if ( !fields ) {
                fields = _super;
                _super = undefined;
            }

            var
            // init is our future class and constructor
            // If no init is provided, make one (Implicit constructor)
                klass = fields.init || ( fields.init = function() {
                    // Automatically calls the superconstructor if there is one.
                    _super && _super.prototype.init.apply( this, arguments );
                } ),

            // Used to make the new klass extends its super class
                protoChainingProxy = function() { },

            // klass.prototype
                proto,

            // index in loop
                name;

            // Prepare prototype chaining to the super class
            // If no super class, use $.klass as implicit super class
            protoChainingProxy.prototype = (_super || $klass).prototype;
            // Make the [[prototype]]'s chain from klass to it's super class
            proto = klass.prototype = new protoChainingProxy;	// At the end we have: klass.prototype.[[prototype]] = protoChainingProxy.prototype = _super.prototype. Here the "new" operator creates the new object with the right prototype chain, but doesn't call the constructor because there is no "()". See also: http://brokenliving.blogspot.com/2009/09/simple-javascript-inheritance.html
            // Now we have: klass.prototype.[[prototype]] = protoChainingProxy.prototype = _super.prototype

            // Accessor for super klass ( can be undefined )
            klass._super = _super;

            // Add each function to the prototype of the new class (they are our new class methods):
            for ( name in fields ) {
                // Add the static variables to the new class:
                if ( name === "_klass" ) $.extend( klass, fields[name] );
                // Each new method keeps a reference to its name and its class, allowing us to find its super method dynamically at runtime:
                else $.isFunction( proto[ name ] = fields[name] ) && ( fields[name]._klass = { klass: klass, name: name } );
            }

            // Sets the constructor for instanciated objects
            proto.constructor = klass;

            return klass;
        },
        Array_slice = [].slice;


    /* $.klass.prototype */
// Properties assigned to it are available from any instance of a class made by $.klass

// Function: this._super( [ methodName,] arguments, args... )
// Calls a super method. Finds the super method dynamically.
// Usages:  this._super( arguments, arg1, arg2, arg3, ... )
// 			this._super( "methodName", arguments, arg1, arg2, arg3, ... )
// Arguments:
// 		methodName	(optional) Name of the super method.
// 					By default, use the name of the calling method.
// 		arguments	You must give the arguments object here.
// 		args...		List of arguments for the super method.
// Note:
// 	- Super methods are found dynamically by the function in the super class using the method's name.
    $klass.prototype._super = function( arg0, arg1 ) {
        var arg0IsArguments = arg0.callee,
            _klass = ( arg0IsArguments ? arg0 : arg1 ).callee._klass,
            name = arg0IsArguments ? _klass.name : arg0,
            superMethod = _klass.klass._super.prototype[ name ];
        return superMethod.apply( this, Array_slice.call( arguments, 1 + ( !arg0IsArguments ) ) );
    };

})( jQuery );