//
//  AngularBlockController.m
//  Ginko
//
//  Created by jrk on 26.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "AngularBlockController.h"


@implementation AngularBlockController
@synthesize normalVector;

- (id) initWithSprite: (Sprite *) spriteToControll
{
	self = [super initWithSprite: spriteToControll];
	if (self)
	{
		cpVect p = [controlledSprite position];
		originalPosition = p;
	}
	return self;
}

//adjusts our blocks drawing offset by the normal vector
- (void) setNormalVector: (cpVect) _normal
{
	normalVector = _normal;
	
//	NSLog(@"norm: %f,%f",normalVector.x,normalVector.y);
	float addx = -8 * normalVector.x;
	float addy = 8 * normalVector.y;

	cpVect p = originalPosition;
	p.x += addx;
	p.y -= addy;
	//[controlledSprite setPosition: p];
	
}

- (void) update
{
	gridPosition = cpv(originalPosition.x/32,originalPosition.y/32);
	
	//NSLog(@"sprite controller %@ grid positon: %f,%f",self ,gridPosition.x, gridPosition.y);
}


#pragma mark -- bounce vector
//returns the reflected version of attackVector
//if there's no reflection or our block was hit by the wrong side
//it will return a zero vector
- (cpVect) bounceVector: (cpVect) attackVector
{
	attackVector = cpvnormalize(attackVector);
	cpVect nvec = cpvnormalize(normalVector);

	//return cpvzero if we're attacked from our block side
	if (cpvdot(attackVector, nvec) >= 0.0f)
		return cpvzero;


	//else let's calc the bounce vector for our mirror side
	//	Vect2 = Vect1 - 2 * WallN * (WallN DOT Vect1)
	// walln = normal
	// vect1 = attack
	
	float ndota = cpvdot(nvec, attackVector);
	cpVect nvec2 = cpvmult(nvec, 2.0f);
	cpVect ndotanvec2 = cpvmult(nvec2, ndota);
	cpVect bounce = cpvnormalize(cpvsub(attackVector, ndotanvec2));
	
	//alt V-=2*Normal_wall*(Normal_wall.V)
	
	/*
	NSLog(@"-- ");	
	NSLog(@"acv: (%f,%f)",attackVector.x,attackVector.y);
	NSLog(@"nvec: (%f,%f)",normalVector.x,normalVector.y);
	NSLog(@"bounce: (%f,%f)",bounce.x,bounce.y);
	NSLog(@"dot acv.nvec: %f",cpvdot(attackVector, normalVector));
	NSLog(@"-- ");
	*/
	
	return bounce;
}

@end
