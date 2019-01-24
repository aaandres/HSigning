
-- Horizontal Signing Lines
-- By Andrés Fernández Cruz - PathScripts/Proin3D
-- January 2019
/*
	Create Horizontal Signing Lines based on picked/given spline.
	
	- All distance values are in system units.
	- Distance values along spline (Stroke, Gap, Seg. Length...) are measured along the spline (not straigth distance)
	- When creating a new signing_line, pick over an existing line. If not, nothing is created.
	- To keep line alignement, create the new signing_lines in Top or Perspective views .
	- Works with any type of shape but ONLY with its first spline.
	- For software creation, you can define position on creation or create it and then assign the spline.
	
	Copy this file in one of the folders below and restart 3dsMax
	"C:\Program Files\Autodesk\3ds Max <ReleaseNumber>\scripts\startup" 
	"C:\Users\<UserName>\AppData\Local\Autodesk\3dsMax\<ReleaseNumber> - 64bit\ENU\scripts\startup" 
*/


plugin simpleObject HSigning
   	name:"HSigning"
   	classID:#(0xb74777, 0x1ddc5ac7)
   	category:"PathScripts"
(
   	parameters main rollout:params
   	(
		spline				type:#node	  	ui:ui_spline
		pathLength		type:#worldUnits default:100.0
		continuos 		type:#boolean 	default:off 		animatable:off 	ui:ui_continuos;
		segLength		type:#worldUnits default:10.0 	ui:ui_segLength;
   		width				type:#worldUnits default:1.0 		ui:ui_width;
   		stroke			type:#worldUnits default:10.0 	ui:ui_stroke;
   		gap				type:#worldUnits default:5.0		ui:ui_gap;
   		wsegs			type:#integer 		default:1		ui:ui_wsegs;
   		stsegs			type:#integer	  	default:1 		ui:ui_stsegs;
		PKStart	  		type:#worldUnits default:0.0		ui:ui_PKStart;
		PKEnd	  		type:#worldUnits default:100.0	ui:ui_PKEnd;
   		Hdist		  		type:#worldUnits default:0.0		ui:ui_Hdist;
   		Vdist		  		type:#worldUnits default:0.0		ui:ui_Vdist;
   		thickness  		type:#float	  		default:0.0		ui:ui_thickness;

		forcePos			type:#boolean 	default:on 		animatable:off 	ui:ui_forcePos 
   		bank 				type:#boolean 	default:off 		animatable:off 	ui:ui_bank 
   		mapCoords 		type:#boolean 	default:off 		animatable:off 	ui:ui_mapCoords
   		manualUpdate type:#boolean 	default:off 		animatable:off 	ui:ui_manualUpdate;
		superf			type:#node	  	ui:ui_surface
		
   		on spline set  arg1 do
   		(
			if Spline != undefined and not this.loading do
			(
				pathLength = curveLength Spline 1
				if PKEnd != pathLength do PKEnd = pathLength
				if PKStart != 0.0 do PKStart = 0.0
				if segLength > pathLength do segLength = pathLength
				if stroke > pathLength do stroke = pathLength
				
				theNode = refs.dependentNodes this firstOnly:true baseObjectOnly:true
				if forcePos and theNode != undefined do
				(
					theNode.transform = Matrix3 1;
					theNode.pos = Spline.pos;
				)
			)
   		)
		
		on segLength set val do
		(
			if val > (PKEnd - PKStart) do segLength = (PKEnd - PKStart)
		)

		on stroke set val do
		(
			if val > (PKEnd - PKStart) do stroke = (PKEnd - PKStart)
		)

		on PKStart set val do
		(
			if val > PKEnd do PKStart = PKEnd
		)

		on PKEnd set val do
		(
			if val < PKStart do PKEnd = PKStart
			if val > pathLength do PKEnd = pathLength
		)
		
		on continuos set val do
		(
			this.params.ui_segLength.enabled = val
			this.params.ui_stroke.enabled = not val
			this.params.ui_gap.enabled = not val
			this.params.ui_stsegs.enabled = not val
		)
	)
	
	
   	rollout params "Params"
   	(
		fn shape_filt obj = isKindOf obj shape
		fn geometry_filt obj = isKindOf obj GeometryClass
			
   		group ""
   		(
			label lb1 "HORIZONTAL SIGNING LINES" offset:[0,-4];
			label lb2 "PathScripts - Jan' 2019" ;
		)
			
		pickbutton ui_spline "Select Path" filter:shape_filt  width:120 autoDisplay:true offset:[0,5];
		checkbox ui_forcePos "Force to Line Position" align:#left offset:[-2,4]	enabled:true;
		
   		group "Continuous: "
   		(
			checkbox ui_continuos "Continuous" align:#left offset:[-2,5];
			spinner ui_segLength  	"Seg. Length:" range:[0.1, 1e9, 0] fieldwidth:64 type:#worldUnits align:#right offset:[0,5];
		)
			
   		group "Broken: "
   		(
			spinner ui_stroke  	"Stroke:" range:[0, 1e9, 0] fieldwidth:64 type:#worldUnits align:#right offset:[0,5];
			spinner ui_gap  		"Gap:" range:[0, 1e9, 0] fieldwidth:64 type:#worldUnits align:#right;
			spinner ui_width   	"Width:" range:[0, 1e9, 0] fieldwidth:64 type:#worldUnits align:#right;
			spinner ui_stsegs   "Stroke Segs:" range:[1, 1e5, 1] fieldwidth:64 type:#integer align:#right offset:[0,5];
			spinner ui_wsegs   "Width Segs:" range:[1, 32, 1] fieldwidth:64 type:#integer align:#right;
		)
		
   		group "Displacement: "
   		(
			spinner ui_PKStart	"Start point:" range:[0, 1e9, 0] fieldwidth:64 type:#worldUnits align:#right offset:[0,5];
			spinner ui_PKEnd	"End point:" range:[0, 1e9, 0] fieldwidth:64 type:#worldUnits align:#right;
			spinner ui_Hdist	"Horiz. Dist:" range:[-1e9, 1e9, 0] fieldwidth:64 type:#worldUnits align:#right offset:[0,5];
			spinner ui_Vdist	"Vert. Dist:" range:[-1e9, 1e9, 0] fieldwidth:64 type:#worldUnits align:#right;
		)
			
   		group "Parallel: "
   		(
			checkbox ui_parallel "Parallel" align:#left offset:[-2,5]	enabled:false;
			spinner ui_numParallel   "Number:" range:[2, 1e9, 2] fieldwidth:64 type:#integer align:#right	enabled:false;
			spinner ui_parallelGap  "Horiz. Gap:" range:[0, 1e9, 0.5] fieldwidth:64 type:#worldUnits align:#right	enabled:false;
		)
		
   		group "Parameters: "
   		(
			spinner ui_thickness	"Thickness:" range:[0, 1e9, 0] fieldwidth:64 type:#float align:#right;
			checkbox ui_bank "bank" align:#left offset:[-2,4]	enabled:false;
			checkbox ui_mapCoords "Generate Map Coords." align:#left	enabled:false;
			label lb3 "Glue to Surface:" align:#left	 offset:[0,4]	enabled:false;
			pickbutton ui_surface "Select Surface" filter:geometry_filt  width:120 autoDisplay:true 	enabled:false;
		)
		
   		group "Update: "
   		(
   			checkbox ui_manualUpdate "Manual Update" align:#left offset:[-2,0]
   			button ui_update "Update" width:71 align:#center offset:[-4,0] tooltip:"Update" --across:2
   		)
		
		edittext email text:"pathscripts@proin3d.org" fieldWidth:148 height:16 bold:true readOnly:true offset:[-10,0]
		
   		on ui_update pressed do
		(
			if manualUpdate do
			(
				manualUpdate = off;
				this.doBuildMesh();
				manualUpdate = on;
			)
		)
		
		on params open do
		(
			if Spline == undefined do ui_spline.enabled = false
			theNode = refs.dependentNodes this firstOnly:true baseObjectOnly:true
			if theNode != undefined do
			(
				this.params.ui_spline.enabled = true
			)
			this.params.ui_segLength.enabled = continuos
			this.params.ui_stroke.enabled = not continuos
			this.params.ui_gap.enabled = not continuos
			this.params.ui_stsegs.enabled = not continuos
		);
		
		on params close do
		(
			if manualUpdate do
			(
				manualUpdate = off;
				this.doBuildMesh();
				manualUpdate = on;
			)
		)
		
	)
	
	
    -- Creation mouse procedure
    tool create
    (
		on start do
		(
			setSysCur #select
		)
		
		on freeMove do
		(
			setSysCur #select
		)
		
		on mouseAbort click do
		(
			theNode = refs.dependentNodes this firstOnly:true baseObjectOnly:true
			delete theNode
			setSysCur #arrow
		)
	
		on mousePoint click do
		(
			case click of
			(
				1: 
				(
					setSysCur #select
					
					local AutoCross, AutoCrossDir;
					local AutoCrossChanged = false;
					AutoCross = getINISetting (getMAXIniFile()) #Performance #AutoCross	--	0
					AutoCrossDir = getINISetting (getMAXIniFile()) #Performance #AutoCrossDir	--	0
					if AutoCross != "0" or AutoCrossDir != "0" do
					(
						AutoCrossChanged = true
						maxOps.setSelectionType	false 0
					)

					objs = boxPickNode (box2 (viewPoint.x-2) (viewPoint.y-2) 6 6) crossing:on 
					
					elpath = undefined
					for o in objs where isKindof o shape do
					(
						elpath = o
						exit
					)
					if elpath != undefined then
					(
						Spline = elpath
						NodeTM.pos = Spline.pos;

						width = 1.0;
						stroke = 5;
						gap = 2.5;
						segLength = 10.0;
						
						this.params.ui_spline.enabled = true;
					)
					
					if AutoCrossChanged do
					(
						autoWindow = if AutoCross == "1" then true else false
						crossing = if AutoCrossDir == "1" then 1 else 0
						maxOps.setSelectionType	autoWindow crossing
						AutoCross = undefined
						AutoCrossDir = undefined
						AutoCrossChanged = false
					)
					
					if elpath == undefined then
					(
						setArrowCursor()
						theNode = refs.dependentNodes this firstOnly:true baseObjectOnly:true
						delete theNode
						#stop
					)
				)
				
				3: 
				(
					setArrowCursor()
					#stop
				)
			)
		)


   		 on mouseMove click do case click of
   		 (
   			 2: 
   			(
				setSysCur #move 
				if not continuos then
				(
					stroke = amin (sqrt ((abs gridDist.x)^2 + (abs gridDist.y)^2))  pathlength;
				)
				else
				(
					segLength = amin (sqrt ((abs gridDist.x)^2 + (abs gridDist.y)^2))  pathlength;
				)
   			)	
   			3: 
   			(
				setSysCur #squash
				if not continuos then
				(
					gap = sqrt ((abs gridDist.x)^2 + (abs gridDist.y)^2);
				)
				else
				(
					setArrowCursor()
					#stop
				)
   			)	
   		 )
	)
	
	
   	fn doBuildMesh =
   	(
		if not manualUpdate and spline != undefined do
		(
			local invLength, numElements;
			local strokeII, gapII, stsegsII, pathLengthII;
			local w, s;
			
			if continuos then
			(
				numElements = 1;
				
				pathLengthII = PKEnd - PKStart
				invLength = 1.0 / pathLength
				strokeII = pathLengthII;
				gapII = 0.0;
				stsegsI = (pathLengthII / segLength) 
				
				w = width / wsegs;
				s = strokeII / stsegsI;
				stsegsII = (ceil stsegsI) as integer
			)
			else
			(
				numElements = 
					(
						pathLengthII = PKEnd - PKStart
						invLength = 1.0 / pathLength
						ceil (pathLengthII / (stroke + gap))
					)
				strokeII = stroke;
				gapII = gap;
				stsegsII = stsegs;
					
				w = width / wsegs;
				s = strokeII / stsegsII;
			)					
			
			nverts = (stsegsII + 1) * (wsegs + 1);		-- Base number, not total number
			nfaces = stsegsII * wsegs * 2;					-- Base number, not total number
				
			setNumVerts mesh (nverts * numElements);
			setNumFaces mesh (nfaces * numElements);
			
			basefaces = #()
			for i = 1 to stsegsII do
			(
				baseFaceNumber = (i-1) * (wsegs * 2);
				baseFaceStep = (i-1) * (wsegs + 1);
				for j = 1 to wsegs do
				(
					faceNumber = baseFaceStep + j;
					basefaces[baseFaceNumber + 2 * j - 1] = [faceNumber, faceNumber + 1, faceNumber + wsegs + 1]
					basefaces[baseFaceNumber + 2 * j] = [faceNumber + wsegs + 2, faceNumber + wsegs + 1, faceNumber + 1]
				)
			)
			for i = 1 to numElements do
			(
				faceStep = (i - 1) * nverts;
				for j = 1 to nfaces do
				(
					fi = (i-1) * nfaces + j;
					setface mesh fi (basefaces[j] + faceStep);
					setEdgeVis mesh  fi 1 true;
					setEdgeVis mesh  fi 3 true;
				)
			)
			
			paramDist = HDist - width*0.5;
			paramEnd = PKEnd*invLength; if paramEnd >= 1 do paramEnd = 0.999; -- Just to solve tangent at end point
			for k = 1 to numElements do
			(
				param0 = PKStart + (strokeII + gapII) * (k-1);
				for i = 1 to stsegsII+1 do
				(
					param = (param0 + (i-1)*s) * invLength;
					if param > paramEnd do param = paramEnd
					p = lengthInterp Spline 1 param - Spline.pos
					t = lengthTangent Spline 1 param
					n = normalize (cross [0,0,-1] t)
					for j = 1 to wsegs+1 do
					(
						p += ((j-1)*w + paramDist) * n
						p.Z += VDist;
						
						setvert mesh ((k-1) * nverts + (i-1) * (wsegs+1) + j) p;
					)
				)
			)
			
			if thickness != 0.0 do
			(
				extrudeFace mesh #all  thickness 100.0 dir:[0,0,1];
				meshop.moveVert mesh #all [0,0,-thickness]
			)
			
			update mesh;
		)
   	)
	
   	on buildmesh do
	(
		doBuildMesh();
	)
)



