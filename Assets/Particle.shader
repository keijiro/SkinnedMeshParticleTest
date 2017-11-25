Shader "Particle"
{
    Properties
    {
        [HDR] _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex("Particle Texture", 2D) = "white" {}
    }

    CGINCLUDE

    #include "UnityCG.cginc"

    half4 _Color;

    sampler2D _MainTex;
    float4 _MainTex_ST;

    struct Varyings
    {
        float4 position : SV_Position;
        float2 texcoord : TEXCOORD0;
        half4 color : COLOR;
    };

    Varyings Vertex(
        float4 position : POSITION,
        float2 texcoord : TEXCOORD0,
        half4 color : COLOR
    )
    {
        Varyings output;
        output.position = UnityObjectToClipPos(position);
        output.texcoord = TRANSFORM_TEX(texcoord, _MainTex);
        output.color = color * _Color;
        return output;
    }

    half4 Fragment(Varyings input) : SV_Target
    {
        return input.color * tex2D(_MainTex, input.texcoord);
    }

    ENDCG

    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
        Blend SrcAlpha One
        Cull Off Lighting Off ZWrite Off
        Pass
        {
            CGPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment
            ENDCG
        }
    }
}
