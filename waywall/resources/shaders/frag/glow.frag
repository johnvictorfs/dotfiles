precision highp float;

#define RGB8(r,g,b)   (vec4((r)/255.0, (g)/255.0, (b)/255.0, 1.0))
#define RGBA8(r,g,b,a) (vec4((r)/255.0, (g)/255.0, (b)/255.0, (a)/255.0))

const vec4 percentage_color = RGB8(63.0, 185.0, 163.0);

//------------------------------------------------------------------------------------------------

varying vec2 f_src_pos;

uniform sampler2D u_texture;

const float threshold = 0.01;

const vec3 spawner = vec3(0.302, 0.882, 0.792);

void main() {
    vec4 color = texture2D(u_texture, f_src_pos);

    bool is_spawner = all(lessThan(abs(color.rgb - spawner), vec3(threshold)));

    if ( is_spawner ) {
        gl_FragColor = percentage_color;
    }
    else {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
}