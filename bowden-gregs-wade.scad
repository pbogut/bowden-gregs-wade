// Greg's Wade Extruder.
// It is licensed under the Creative Commons - GNU GPL license.
//  2010 by GregFrost
// Extruder based on prusa git repo.
// http://www.thingiverse.com/thing:6713

include <configuration.scad>
include <jonaskuehling-default.scad>
include <polyScrewThread_r1.scad>

//Set motor- and bolt-elevation for additional clearance when using e.g. 9/47 gears like in http://www.thingiverse.com/thing:11152
elevation=4;

//Set extra gear separation when using slightly bigger non-standard gears like 9/47 herringbone gears
extra_gear_separation=2;

// Nut wrench sizes ISO 4032
m3_wrench = 5.5;
m4_wrench = 7;

// Adjust for deeper groove in hobbed bolt, so that idler is still vertical when tightened
// Values like 0.5 to 1 should work, the more, the closer the idler will move to the bolt
// Sometimes the idler will be slightly angled towards the bolt which causes the idler screws
// to slip off the slots in die idler to the top.. Adjusting this should help:
less_idler_bolt_dist = 0;



// RENDER GEARS //
%	translate(motor_mount_translation) {
		translate([-gear_separation,0,0])
			rotate([0,180,0])
				translate([0,0,8])
					import("large_gear.stl");
		translate([0,0,-8])
			import("small_gear.stl");
}


// RENDER EXTRUDER //
wade();

// RENDER IDLER //
translate([78+extra_gear_separation,-10,16.20])		// POSITIONING
	rotate([0,-90,0])
		wadeidler();


// RENDER IDLER BEARING BOLT //
translate([75,55,0])		// POSITIONING
	idler_bearing_bolt();


// RENDER BEARING M5 WASHER //
translate([30,20,0])		// POSITIONING
	bearing_m5_washer();
translate([30,10,0])		// POSITIONING
	bearing_m5_washer();


/**
 * Extruder
 * @name Extruder
 * @assembled
 * @using 1 small-gear
 * @id extruder
 * @using 1 idler
 * @using 1 extruder-body
 * @using 1 m3nut
 * @using 1 m3washer
 * @using 1 m3x25
 * @step Take idler and insert nut into small nut-trap inside the hinge.
 * @step While holding the nut in place, preprare M3x25 bolt with washer and screw it into the hinge just enough to hold the nut.
 * @step Now take the extruder body and idler. Place idler on the hinge counterpart and compleately screw the M3x25 bolt. This will create secured hinge.
 *
 * @using 2 m4nut
 * @step Place M4 nuts into their nut traps, secure them with piece of tape. We need them in place, since later they would be harder to access.
 *
 * @using 3 m3x10
 * @using 3 m3washer
 * @using 1 NEMA17
 * @step Prepare your NEMA17 stepper motor and three M3x10 screws with washers.
 * @step Hold motor on place and lightly tighten the screws. We need to adjust motor position later, no need to tighten it hard.
 *
 * @using 1 large-gear
 * @using 1 m8washer
 * @using 2 m8nut
 * @using 2 bearing-608
 * @step Place two skate bearings on ther position, they should snuggly fit in.
 * @step Insert prepared large gear into the body with mounted bearings.
 * @step Check if the alignment of hobbed part with the filament path. Adjust it accordingly with adding or removing M8 washers.
 * @step After adjusting, we need to fix the bolt in. So we place washer at the end of hobbed bolt and with two M8 nuts we will do locknut by tightening them against each other.
 * @step Check if large gear turns freely.
 *
 * @using 2 m3x40
 * @using 4 m3washer
 * @using 2 extruder-spring
 * @step Prepare two M3x40 screws with sandwitch of washer-spring-washer.
 * @step Insert two M3 nuts into nut traps on top of drive mechanism. [[extruder/top-nut-traps.png]]
 * @step Insert prepared screws into the holes on idler. Close the idler and tighten the screws into the trapped nuts. More you tighten those screws, more pressure will be on fillament.
 * @step Your extruder is done. [[extruder/assembled.jpg]]
 */

/**
 * Extruder body
 * @name Extruder body
 * @category Printed
 * @id extruder-body
 */

/**
 * Extruder idler
 * @name Extruder Idler
 * @id idler
 * @category Printed
 * @using 1 bearing-608
 * @using 1 idler-m8-piece
 * @step Insert piece of M8 rod into bearing.
 * @step Insert 608 bearing with rod into printed idler part.
 */

/**
 * Small M8 rod
 * @name Idler
 * @id idler-m8-piece
 * @category Rods and Bars
 */

/**
 * Spring used for idler on extruder.
 * @name Extruder spring
 * @id extruder-spring
 */

//===================================================
// Parameters defining the wade body:
wade_block_height=55+elevation;
wade_block_width=24;
wade_block_depth=28;

block_bevel_r=6;

base_thickness=7;
base_length=70;
base_leadout=25;

nema17_hole_spacing=1.2*25.4;
nema17_width=1.7*25.4;
nema17_support_d=nema17_width-nema17_hole_spacing;

screw_head_recess_diameter=7.2;
screw_head_recess_depth=3;

motor_mount_rotation=25;
motor_mount_translation=[50.5+extra_gear_separation,34+elevation,0];
motor_mount_thickness=8;

new_clearance_hole=14;
hole_for_608=22.6;
608_diameter=22;

block_top_right=[wade_block_width,wade_block_height];

layer_thickness=0.25;
filament_feed_hole_d=3.5;
filament_diameter=3;
filament_feed_hole_offset=filament_diameter+1.5;
idler_nut_trap_depth=7.3;
idler_nut_thickness=3.7;

gear_separation=7.4444+32.0111+0.25+extra_gear_separation;

function motor_hole(hole)=[motor_mount_translation[0],motor_mount_translation[1]] +
	rotated(45+motor_mount_rotation+hole*90)*nema17_hole_spacing/sqrt(2);

// Parameters defining the idler.

filament_pinch=[
	motor_mount_translation[0]-gear_separation-filament_feed_hole_offset-filament_diameter/2,
	motor_mount_translation[1],
	wade_block_depth/2];
	block_shift=11.8;
idler_axis=filament_pinch-[608_diameter/2,0,0];
idler_fulcrum_offset=608_diameter/2+3.5+m3_diameter/2;
idler_fulcrum=idler_axis-[0+less_idler_bolt_dist,idler_fulcrum_offset,0];
idler_corners_radius=4;
idler_height=12;
idler_608_diameter=608_diameter+2;
idler_608_height=9;
idler_mounting_hole_across=8;
idler_mounting_hole_up=15;
idler_short_side=wade_block_depth-2;
idler_hinge_r=m3_diameter/2+3.5;
idler_hinge_width=6.5;
idler_end_length=(idler_height-2)+5;
idler_mounting_hole_diameter=m4_diameter+0.25;
idler_mounting_hole_elongation=0.9;
idler_long_top=idler_mounting_hole_up+idler_mounting_hole_diameter/2+idler_mounting_hole_elongation+2.5;
idler_long_bottom=idler_fulcrum_offset;
idler_long_side=idler_long_top+idler_long_bottom;

module bearing_m5_washer() {
	difference() {
		cylinder(7, r=4, $fn=50);
		translate([0, 0, -0.5])
			cylinder(8, r=2.6, $fn=50);
	}
}

module idler_bearing_bolt() {
	cylinder(18, r=3.95, $fn=50);
}

module wade (){
	difference (){
		union(){
			// The wade block.
			translate([0,block_shift,0]) {
				/* cube([wade_block_width,wade_block_height-block_shift,wade_block_depth]); */
				difference() {
					cube([wade_block_width,wade_block_height-block_shift,wade_block_depth]);
					// Some chamfer just for ascetic and maybe plastic save, not necessary
						translate([30, 0, -1])
								cylinder(wade_block_depth+2, r=16, $fn=60);
						rotate(25, [1,0,0])
							translate([-1, -2, -5])
								cube([wade_block_width,5,15]);
						translate([0,0,28])
							rotate(25, [-1,0,0])
								translate([-1, -2, -10])
									cube([wade_block_width,5,15]);
				}
			}

			// Filler between wade block and motor mount.
			translate([10,motor_mount_translation[1]-hole_for_608/2,0])
			cube([wade_block_width+extra_gear_separation,
				wade_block_height-motor_mount_translation[1]+hole_for_608/2,
				motor_mount_thickness]);

			// Connect block to top of motor mount.
			linear_extrude(height=motor_mount_thickness)
			barbell(block_top_right-[0,5],motor_hole(0),5,nema17_support_d/2,100,60);

			//Connect motor mount to base.
			linear_extrude(height=motor_mount_thickness)
			barbell([base_length-base_leadout,
				20,],motor_hole(2),base_thickness/2,
				nema17_support_d/2,100,60);

			// The idler hinge.
			translate(idler_fulcrum){
				translate([idler_hinge_r,0,0])
				cube([idler_hinge_r*2,idler_hinge_r*2,idler_short_side-2*idler_hinge_width-0.5],
					center=true);
				rotate(-30){
					cylinder(r=idler_hinge_r,
						h=idler_short_side-2*idler_hinge_width-0.5,
						center=true,$fn=60);
					translate([idler_hinge_r,0,0])
					cube([idler_hinge_r*2,idler_hinge_r*2,
						idler_short_side-2*idler_hinge_width-0.5],
						center=true);
				}
			}

			// The idler hinge support.
			translate(idler_fulcrum){
				rotate(-15)
				translate([-(idler_hinge_r+3)+1,-idler_hinge_r-2,-wade_block_depth/2])
				difference(){
					cube([idler_hinge_r+3,
						idler_hinge_r*2+4,
						wade_block_depth/2-
						idler_short_side/2+
						idler_hinge_width+0.25+
						layer_thickness]);
					translate([idler_hinge_r+2,(idler_hinge_r*2+4)/2,-layer_thickness])
					cylinder(r=idler_hinge_r+1,h=10,$fn=50);
				}
				rotate(-15)
				translate([-(idler_hinge_r+3)+1,-idler_hinge_r-2,
					-idler_short_side/2+idler_hinge_width+0.25])
				cube([idler_hinge_r+3+9,
					idler_hinge_r*2+4,
					layer_thickness]);
			}



			motor_mount ();
		}


		block_holes();
		motor_mount_holes();

		translate([motor_mount_translation[0]-gear_separation-filament_feed_hole_offset,
			block_shift,wade_block_depth/2])
			rotate([-90,0,0]){
				pc4_m10_hole();
			}
	}
}

function in_mask(mask,value)=(mask%(value*2))>(value-1);

//block_holes();

module block_holes(){
	//Round off the top of the block.
	translate([0,wade_block_height-block_bevel_r,-1])
	render()
	difference(){
		translate([-1,0,0])
		cube([block_bevel_r+1,block_bevel_r+1,wade_block_depth+2]);
		translate([block_bevel_r,0,0])
		cylinder(r=block_bevel_r,h=wade_block_depth+2,$fn=40);
	}

	// Round the top front corner.
	translate ([-base_leadout-base_thickness/2,-1,wade_block_depth-block_bevel_r])
	render()
	difference(){
		translate([-1,0,0])
		cube([block_bevel_r+1,base_thickness+2,block_bevel_r+1]);
		rotate([-90,0,0])
		translate([block_bevel_r,0,-1])
		cylinder(r=block_bevel_r,h=base_thickness+4);
	}

	// Round the top back corner.
	translate ([base_length-base_leadout+base_thickness/2-block_bevel_r,
		-1,wade_block_depth-block_bevel_r])
	render()
	difference(){
		translate([0,0,0])
		cube([block_bevel_r+1,base_thickness+2,block_bevel_r+1]);
		rotate([-90,0,0])
		translate([0,0,-1])
		cylinder(r=block_bevel_r,h=base_thickness+4);
	}

	// Round the bottom front corner.
	translate ([-base_leadout-base_thickness/2,-1,-2])
	render()
	difference(){
		translate([-1,0,-1])
		cube([block_bevel_r+1,base_thickness+2,block_bevel_r+1]);
		rotate([-90,0,0])
		translate([block_bevel_r,-block_bevel_r,-1])
		cylinder(r=block_bevel_r,h=base_thickness+4);
	}

	// Idler fulcrum hole.
	translate(idler_fulcrum+[0,0,0.4])
	cylinder(r=m3_diameter/2,h=idler_short_side-2*idler_hinge_width-0.5,center=true,$fn=16);

	translate(idler_fulcrum+[0,0,idler_short_side/2-idler_hinge_width-1])
	cylinder(r=m3_nut_diameter/2+0.25,h=1,$fn=40);

	//Rounded cutout for idler hinge.
	render()
	translate(idler_fulcrum)
	difference(){
		cylinder(r=idler_hinge_r+0.5,h=idler_short_side+0.5,center=true,$fn=60);
		cylinder(r=idler_hinge_r+1,h=idler_short_side-2*idler_hinge_width-0.5,center=true);
	}

	translate(motor_mount_translation){
		translate([-gear_separation,0,0]){
			// Open the top to remove overhangs and to provide access to the hobbing.
			translate([-wade_block_width+2,0,9.5])
			cube([wade_block_width,
				wade_block_height-motor_mount_translation[1]+1,
				wade_block_depth]);

			// Open 30° slot for idler screws to avoid overhang at top corner
			translate([-wade_block_width+2,idler_mounting_hole_up-(idler_mounting_hole_diameter/2),wade_block_depth/2-idler_mounting_hole_across-((idler_mounting_hole_diameter*cos(180/6))/2)])
			cube([wade_block_width,
				wade_block_height-motor_mount_translation[1]+1,
				wade_block_depth]);

			translate([0,0,-1])
			b608(h=9);

			translate([0,0,20])
			b608(h=9);

			translate([-13,0,9.5])
			b608(h=wade_block_depth);

			translate([0,0,8+layer_thickness])
			cylinder(r=new_clearance_hole/2,h=wade_block_depth-(8+layer_thickness)+2);

			translate([0,0,20-2])
			cylinder(r=16/2,h=wade_block_depth-(8+layer_thickness)+2);

			// Filament feed.
			translate([-filament_feed_hole_offset,0,wade_block_depth/2])
			rotate([90,0,0])
			rotate(360/16)
			// cylinder(r=filament_feed_hole_d/2,h=wade_block_depth*3,center=true,$fn=8);
			cylinder(r=2,h=wade_block_depth*3,center=true,$fn=32);
		}
	}

	// Idler mounting holes and nut traps.
	for (idle=[-1,1]){
		translate([0,
			idler_mounting_hole_up+motor_mount_translation[1],
			wade_block_depth/2+idler_mounting_hole_across*idle])
		rotate([0,90,0]){
			rotate([0,0,30]){
				// screw holes
				translate([0,0,-1])
				cylinder(r=idler_mounting_hole_diameter/2,h=wade_block_depth+6,$fn=6);

				// nut traps
				translate([0,0,wade_block_width-idler_nut_trap_depth+idler_nut_thickness/2])
//				cylinder(r=m4_nut_diameter/2,h=idler_nut_thickness,$fn=6);
				nut_trap(m4_wrench,idler_nut_thickness);
			}
			// nut slots
			translate([0,10/2,wade_block_width-idler_nut_trap_depth+idler_nut_thickness/2])
			cube([m4_wrench+0.4,10,idler_nut_thickness],center=true);

			// screw holes 30°
			for(tilt=[1:6]){
				translate([0,0,(wade_block_width-idler_nut_trap_depth+idler_nut_thickness/2)])
				rotate([tilt*5,0,0])
				rotate([0,0,30])
				translate([0,0,-28])
				cylinder(r=idler_mounting_hole_diameter/2,h=wade_block_depth+10,$fn=6);
			}

			// nut traps 30°
			translate([0,0,wade_block_width-idler_nut_trap_depth+idler_nut_thickness/2])
			for(tilt_nut=[1:6])
				rotate([tilt_nut*5,0,0])
				rotate([0,0,30])
//				cylinder(r=m4_nut_diameter/2,h=idler_nut_thickness,$fn=6);
				nut_trap(m4_wrench,idler_nut_thickness);



		}
	}
}

module motor_mount(){
	linear_extrude(height=motor_mount_thickness){
		barbell (motor_hole(0),motor_hole(1),nema17_support_d/2,
			nema17_support_d/2,20,160);
		barbell (motor_hole(1),motor_hole(2),nema17_support_d/2,
			nema17_support_d/2,20,160);
	}
}

module motor_mount_holes(){
	radius=4/2;
	slot_left=1;
	slot_right=2;

	{
		translate([0,0,screw_head_recess_depth+layer_thickness])
		for (hole=[0:2]){
			translate([motor_hole(hole)[0]-slot_left,motor_hole(hole)[1],0])
			cylinder(h=motor_mount_thickness-screw_head_recess_depth,r=radius,$fn=16);
			translate([motor_hole(hole)[0]+slot_right,motor_hole(hole)[1],0])
			cylinder(h=motor_mount_thickness-screw_head_recess_depth,r=radius,$fn=16);

			translate([motor_hole(hole)[0]-slot_left,motor_hole(hole)[1]-radius,0])
			cube([slot_left+slot_right,radius*2,motor_mount_thickness-screw_head_recess_depth]);
		}

		translate([0,0,-1])
		for (hole=[0:2]){
			translate([motor_hole(hole)[0]-slot_left,motor_hole(hole)[1],0])
			cylinder(h=screw_head_recess_depth+1,
				r=screw_head_recess_diameter/2,$fn=16);
			translate([motor_hole(hole)[0]+slot_right,motor_hole(hole)[1],0])
			cylinder(h=screw_head_recess_depth+1,
				r=screw_head_recess_diameter/2,$fn=16);

			translate([motor_hole(hole)[0]-slot_left,
				motor_hole(hole)[1]-screw_head_recess_diameter/2,0])
			cube([slot_left+slot_right,
				screw_head_recess_diameter,
				screw_head_recess_depth+1]);
		}
	}
}

module wadeidler(){
	guide_height=12.3;
	guide_length=10;

	difference(){
		union(){
			//The idler block.
			translate(idler_axis+[-idler_height/2+2,+idler_long_side/2-idler_long_bottom,0]){
				cube([idler_height,idler_long_side,idler_short_side],center=true);

				//Filament Guide.
				translate([guide_height/2+idler_height/2-1,idler_long_side/2-guide_length/2,0])
				cube([guide_height+1,guide_length,8],center=true);
			}

			// The fulcrum Hinge
			translate(idler_fulcrum)
			rotate([0,0,-30]){
				cylinder(h=idler_short_side,r=idler_hinge_r,center=true,$fn=60);
				translate([-idler_end_length/2,0,0])
				cube([idler_end_length,idler_hinge_r*2,idler_short_side],center=true);
			}
		}

		//Filament Path
		translate(idler_axis+[2+guide_height,+idler_long_side-idler_long_bottom-guide_length/2,0]){
			/* cube([7,guide_length+2,3.5],center=true); */
			translate([-7/2,0,0])
			rotate([90,0,0]) {
				cylinder(h=guide_length+4,r=3/2,center=true,$fn=16);
				translate([0,0,-4])
				// hole for bowden tube, that can be used as a guide
				cylinder(r=4/2,h=5,center=true,$fn=32);
				// big enough for easy filament replacement but small enough to keep bowden tube in place
				translate([5,0,0])
					cube([10,2.4,guide_length+4], center=true);
			}
		}


		//Back of idler. Rueckseite glaetten
		translate(idler_axis+[-idler_height/2+2-idler_height,
			idler_long_side/2-idler_long_bottom-10,0])
		cube([idler_height,idler_long_side,idler_short_side+2],center=true);

		//Slot for idler fulcrum mount. Ausbruch Aufhaengung
		translate(idler_fulcrum){
			cylinder(h=idler_short_side-2*idler_hinge_width,
				r=idler_hinge_r+0.5,center=true,$fn=60);
			rotate(-30)
			translate([0,-idler_hinge_r-0.5,0])
			cube([idler_hinge_r*2+1,idler_hinge_r*2+1,
				idler_short_side-2*idler_hinge_width],center=true);

		}

		//Bearing cutout. Kugelleager Aufhaengung
		translate(idler_axis){
			difference(){
				cylinder(h=idler_608_height,r=idler_608_diameter/2,
					center=true,$fn=60);
				for (i=[0,1])
				rotate([180*i,0,0])
				translate([0,0,6.9/2])
				cylinder(r1=12/2,r2=16/2,h=2);
			}
			cylinder(h=idler_short_side-6,r=m8_diameter/2-0.25/*Tight*/,
				center=true,$fn=20);
		}

		//Fulcrum hole. Gelenkloch
		translate(idler_fulcrum)
		rotate(360/12)
		cylinder(h=idler_short_side+2,r=m3_diameter/2-0.1,center=true,$fn=8);

		//Nut trap for fulcrum screw. Loch fuer Mutter
		translate(idler_fulcrum+[0,0,idler_short_side/2-idler_hinge_width-1+1.5])
		nut_trap(m3_wrench,3);

		for(idler_screw_hole=[-1,1])
		translate(idler_axis+[2-idler_height,0,0]){
			//Screw Holes. Schraubenloecher
			translate([-1,idler_mounting_hole_up-1,
				idler_screw_hole*idler_mounting_hole_across])
			rotate([0,90,0]){
				cylinder(r=idler_mounting_hole_diameter/2,h=idler_height+2,$fn=16);
				translate([0,idler_mounting_hole_elongation+0.8,0])
				cylinder(r=idler_mounting_hole_diameter/2,h=idler_height+2,$fn=16);
				translate([-idler_mounting_hole_diameter/2,0,0])
				cube([idler_mounting_hole_diameter,idler_mounting_hole_elongation+7,
					idler_height+2]);
			}

			// Rounded corners.
			render()
			translate([idler_height/2,idler_long_top,
				idler_screw_hole*(idler_short_side/2)])
			difference(){
				translate([0,-idler_corners_radius/2+0.5,-idler_screw_hole*(idler_corners_radius/2-0.5)])
				cube([idler_height+2,idler_corners_radius+1,idler_corners_radius+1],
					center=true);
				rotate([0,90,0])
				translate([idler_screw_hole*idler_corners_radius,-idler_corners_radius,0])
				cylinder(h=idler_height+4,r=idler_corners_radius,center=true,$fn=40);
			}
		}
	}
}

module b608(h=8){
	translate([0,0,h/2]) cylinder(r=hole_for_608/2,h=h,center=true,$fn=60);
}

module barbell (x1,x2,r1,r2,r3,r4) {
	x3=triangulate (x1,x2,r1+r3,r2+r3);
	x4=triangulate (x2,x1,r2+r4,r1+r4);
	render()
	difference (){
		union(){
			translate(x1)
			circle (r=r1);
			translate(x2)
			circle(r=r2);
			polygon (points=[x1,x3,x2,x4]);
		}

		translate(x3)
		circle(r=r3,$fa=5);
		translate(x4)
		circle(r=r4,$fa=5);
	}
}

function triangulate (point1, point2, length1, length2) =
point1 +
length1*rotated(
atan2(point2[1]-point1[1],point2[0]-point1[0])+
angle(distance(point1,point2),length1,length2));

function distance(point1,point2)=
sqrt((point1[0]-point2[0])*(point1[0]-point2[0])+
(point1[1]-point2[1])*(point1[1]-point2[1]));

function angle(a,b,c) = acos((a*a+b*b-c*c)/(2*a*b));

function rotated(a)=[cos(a),sin(a),0];

//========================================================
// Modules for defining holes for hotend mounts:
// These assume the extruder is verical with the bottom filament exit hole at [0,0,0].

module pc4_m10_hole(){
	// Recess in base
	translate([0,0,-1])
	union() {
		screw_thread(10,1.5,60,10,PI/2,0);
		cylinder(r=4,h=10);
	}
}
