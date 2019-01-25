# HSigning
MaxScript Geometry Object Plugin for Horizontal Signing Lines

HSigning is just a working prototype of a SimpleObject plugin to create horizontal signing (dashed and continuous lines) geometry objects.

Copy the file into one of the startup folders:
"C:\Program Files\Autodesk\3ds Max <ReleaseNumber>\scripts\startup"
or
"C:\Users\<UserName>\AppData\Local\Autodesk\3dsMax\<ReleaseNumber> - 64bit\ENU\scripts\startup"),
restart 3dsMax, and you'll find the Geometry Object under the 'PathScritps' section.
  
  You can create HSigning by picking any shape in the scene.

- All distance values are in system units.
- Distance values along spline (Stroke, Gap, Seg. Length...) are measured along the spline (not straigth distance)
- When creating a new signing_line, pick over an existing line. If not, nothing is created.
- To keep line alignement, create the new signing_lines in Top or Perspective views.
- This prototype version works with any type of shape but ONLY with one spline at a time.
- For software creation, you can define position on creation or create the object and then assign the spline.

If there's interest (I mean commercial interest), I'll develop the C# version with all missing features:

- Work with multispline shapes at a time.
- Mapping coordinates.
- Banking.
- Gluing to surface.

