#include "/lib/settings.glsl"

uniform sampler2D colortex4;
uniform sampler2D colortex1;
uniform sampler2D colortex12;

uniform vec2 texelSize;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

#ifdef DISTANT_HORIZONS
uniform sampler2D dhDepthTex;
uniform sampler2D dhDepthTex1;
#endif
uniform float near;
uniform float far;
uniform float dhFarPlane;
uniform float dhNearPlane;

float linZ(float depth) {
    return (2.0 * near) / (far + near - depth * (far - near));
}
float DH_linZ(float dist) {
    return (2.0 * dhNearPlane) / (dhFarPlane + dhNearPlane - dist * (dhFarPlane - dhNearPlane));
}
float DH_invLinZ (float lindepth){
	return -((2.0*dhNearPlane/lindepth)-dhFarPlane-dhNearPlane)/(dhFarPlane-dhNearPlane);
}
void convertHandDepth(inout float depth) {
    float ndcDepth = depth * 2.0 - 1.0;
    ndcDepth /= MC_HAND_DEPTH;
    depth = ndcDepth * 0.5 + 0.5;
}
vec2 decodeVec2(float a){
    const vec2 constant1 = 65535. / vec2( 256., 65536.);
    const float constant2 = 256. / 255.;
    return fract( a * constant1 ) * constant2 ;
}
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////

void main() {
/* RENDERTARGETS:4,12 */
	vec3 oldTex = texelFetch2D(colortex4, ivec2(gl_FragCoord.xy), 0).xyz;
	float newTex = texelFetch2D(depthtex1, ivec2(gl_FragCoord.xy*4), 0).x;

	#ifdef DISTANT_HORIZONS
    	float QuarterResDepth = texelFetch2D(dhDepthTex, ivec2(gl_FragCoord.xy*4), 0).x;
		QuarterResDepth = DH_linZ(QuarterResDepth);
   		gl_FragData[1].a = QuarterResDepth*QuarterResDepth*65000.0;
	#endif
	
	newTex = linZ(newTex);
	gl_FragData[0] = vec4(oldTex, newTex*newTex*65000.0);
}