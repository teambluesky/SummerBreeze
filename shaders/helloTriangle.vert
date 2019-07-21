#version 450
#include "intersec.glsl"

layout(location = 0) in vec2 inPosition;
layout(location = 1) in vec3 inColour;
layout(location = 0) out vec3 fragColour;

float WIDTH = 800;
float HEIGHT = 600;

layout (binding = 0) uniform Uniform {
  vec3 spherePosition;
  float sphereRadius;
} u;

struct Light {
  vec3 position;
};

struct Sphere {
  vec3 position;
  float radius;
};


Light light;


Hit check_intersect(Ray ray, Sphere sphere) {
  vec3 center =  sphere.position;
  float radius = sphere.radius;
  float radius2 = radius * radius;

  vec3 L = center - ray.origin;
  float tca = dot(L, ray.direction);

  Hit hit;
  hit.did_hit = false;
  hit.distance = 0.0f;

  if (tca < 0)
  {
      return hit;
  } else {
    float d2 = dot(L, L) - tca * tca;
    if (d2 > radius2)
    {
        return hit;
    } else {
      float thc = sqrt(radius2 - d2);
      float t0 = tca - thc;
      float t1 = tca + thc;
      if (t0 < 0.0f)
      {
          // if t0 is negative, let's use t1 instead
          t0 = t1;
          if (t0 < 0)
          {
              // both t0 and t1 are negative
              return hit;
          }
      }

      hit.did_hit = true;
      hit.distance = t0;
      return hit;
    }
  }
}

void main() {
  light.position = vec3(0, -9, -9);

  gl_Position = vec4(inPosition, 0.0, 1.0); // Copy 2D position to 3D + depth
  gl_Position.x = gl_Position.x * (WIDTH / HEIGHT);

  Ray ray;
  ray.origin = vec3(0, 0, 1);

  vec3 direction = normalize(-ray.origin + gl_Position.xyz);
  direction = normalize(vec3(direction.x, direction.y, direction.z));
  ray.direction = direction;

  fragColour = vec3(0, 0, 0);

  // build scene
  Sphere sphere; sphere.radius = u.sphereRadius; sphere.position = u.spherePosition;

  // ray-sphere intersection
  Hit hit = check_intersect(ray, sphere);
  if (hit.did_hit) { // we hit the sphere
    // send ray from sphere to light
    vec3 hitPoint = ray.origin + ray.direction*hit.distance;
    vec3 sphere_light_dir = normalize(light.position - hitPoint);
    Ray shadowRay; shadowRay.origin = hitPoint; shadowRay.direction = sphere_light_dir;

    Hit tmpHit = check_intersect(shadowRay, sphere);
    if (tmpHit.did_hit) { // we have hit so we are in shadow do not color
      fragColour = vec3(0,0,0);
      return;
    }
    // we did directly hit light compute simple light energy
    float light_intensity = dot(ray.direction, sphere_light_dir);

    fragColour = vec3(1, 1, 1)*light_intensity;
  }
}
