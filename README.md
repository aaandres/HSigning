# HSigning
MaxScript Geometry Object Plugin for Horizontal Signing Lines

HSigning is just a working prototype of a SimpleObject plugin to create horizontal signing (dashed and continuous lines) geometry objects.

  
  You can create HSigning by picking any shape in the scene.

- All distance values are in system units.
- Distance values along spline (Stroke, Gap, Seg. Length...) are measured along the spline (not straigth distance)
- When creating a new signing_line, pick over an existing line. If not, nothing is created.
	  * First mouse drag: segments length
	  * Second mouse drag: segments gap
- To keep line alignement, create the new signing_lines in Top or Perspective views.
- This prototype version works with any type of shape but ONLY with one spline at a time.
	  CAUTION: if shape baseObject is a LINE it will be converted to SplineShape, with no possible UNDO.
				    ONLY baseObject is changed. All modifiers remain as they were before.
				    In this case, the HSigning will be created but the creation will be interrumpted and no mouse dragging is possible.
- For software creation, you can define position on creation or create the object and then assign the spline.

If there's interest (I mean commercial interest), I'll develop the C# version with all missing features:

- Work with multispline shapes at a time.
- Mapping coordinates.
- Banking.
- Gluing to surface.

Copy this file in one of the folders below and restart 3dsMax
	"C:\Program Files\Autodesk\3ds Max <ReleaseNumber>\scripts\startup" 
	"C:\Users\<UserName>\AppData\Local\Autodesk\3dsMax\<ReleaseNumber> - 64bit\ENU\scripts\startup" 
	
A new Geometry Object 'HSigning' will appear under the 'PathScripts' category.
