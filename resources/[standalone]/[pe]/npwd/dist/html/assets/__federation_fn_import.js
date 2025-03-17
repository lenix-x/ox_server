import{_ as ge}from"./preload-helper-a4192956.js";let B,q,x,be=(async()=>{const A="[0-9A-Za-z-]+",R=`(?:\\+(${A}(?:\\.${A})*))`,p="0|[1-9]\\d*",h="[0-9]+",T="\\d*[a-zA-Z-][a-zA-Z0-9-]*",V=`(?:${h}|${T})`,F=`(?:-?(${V}(?:\\.${V})*))`,z=`(?:${p}|${T})`,E=`(?:-(${z}(?:\\.${z})*))`,L=`${p}|x|X|\\*`,m=`[v=\\s]*(${L})(?:\\.(${L})(?:\\.(${L})(?:${E})?${R}?)?)?`,G=`^\\s*(${m})\\s+-\\s+(${m})\\s*$`,H=`(${h})\\.(${h})\\.(${h})`,J=`[v=\\s]*${H}${F}?${R}?`,y="((?:<|>)?=?)",K=`(\\s*)${y}\\s*(${J}|${m})`,S="(?:~>?)",N=`(\\s*)${S}\\s+`,Z="(?:\\^)",Q=`(\\s*)${Z}\\s+`,W="(<|>)?=?\\s*\\*",Y=`^${Z}${m}$`,ee=`(${p})\\.(${p})\\.(${p})`,re=`v?${ee}${E}?${R}?`,te=`^${S}${m}$`,ne=`^${y}\\s*${m}$`,$e=`^${y}\\s*(${re})$|^$`,ie="^\\s*>=\\s*0.0.0\\s*$";function l(e){return new RegExp(e)}function c(e){return!e||e.toLowerCase()==="x"||e==="*"}function k(...e){return n=>e.reduce((i,r)=>r(i),n)}function P(e){return e.match(l($e))}function C(e,n,i,r){const t=`${e}.${n}.${i}`;return r?`${t}-${r}`:t}function oe(e){return e.replace(l(G),(n,i,r,t,$,o,u,a,f,s,_,g)=>(c(r)?i="":c(t)?i=`>=${r}.0.0`:c($)?i=`>=${r}.${t}.0`:i=`>=${i}`,c(f)?a="":c(s)?a=`<${+f+1}.0.0-0`:c(_)?a=`<${f}.${+s+1}.0-0`:g?a=`<=${f}.${s}.${_}-${g}`:a=`<=${a}`,`${i} ${a}`.trim()))}function ae(e){return e.replace(l(K),"$1$2$3")}function ue(e){return e.replace(l(N),"$1~")}function ce(e){return e.replace(l(Q),"$1^")}function se(e){return e.trim().split(/\s+/).map(n=>n.replace(l(Y),(i,r,t,$,o)=>c(r)?"":c(t)?`>=${r}.0.0 <${+r+1}.0.0-0`:c($)?r==="0"?`>=${r}.${t}.0 <${r}.${+t+1}.0-0`:`>=${r}.${t}.0 <${+r+1}.0.0-0`:o?r==="0"?t==="0"?`>=${r}.${t}.${$}-${o} <${r}.${t}.${+$+1}-0`:`>=${r}.${t}.${$}-${o} <${r}.${+t+1}.0-0`:`>=${r}.${t}.${$}-${o} <${+r+1}.0.0-0`:r==="0"?t==="0"?`>=${r}.${t}.${$} <${r}.${t}.${+$+1}-0`:`>=${r}.${t}.${$} <${r}.${+t+1}.0-0`:`>=${r}.${t}.${$} <${+r+1}.0.0-0`)).join(" ")}function fe(e){return e.trim().split(/\s+/).map(n=>n.replace(l(te),(i,r,t,$,o)=>c(r)?"":c(t)?`>=${r}.0.0 <${+r+1}.0.0-0`:c($)?`>=${r}.${t}.0 <${r}.${+t+1}.0-0`:o?`>=${r}.${t}.${$}-${o} <${r}.${+t+1}.0-0`:`>=${r}.${t}.${$} <${r}.${+t+1}.0-0`)).join(" ")}function le(e){return e.split(/\s+/).map(n=>n.trim().replace(l(ne),(i,r,t,$,o,u)=>{const a=c(t),f=a||c($),s=f||c(o);return r==="="&&s&&(r=""),u="",a?r===">"||r==="<"?"<0.0.0-0":"*":r&&s?(f&&($=0),o=0,r===">"?(r=">=",f?(t=+t+1,$=0,o=0):($=+$+1,o=0)):r==="<="&&(r="<",f?t=+t+1:$=+$+1),r==="<"&&(u="-0"),`${r+t}.${$}.${o}${u}`):f?`>=${t}.0.0${u} <${+t+1}.0.0-0`:s?`>=${t}.${$}.0${u} <${t}.${+$+1}.0-0`:i})).join(" ")}function me(e){return e.trim().replace(l(W),"")}function pe(e){return e.trim().replace(l(ie),"")}function v(e,n){return e=+e||e,n=+n||n,e>n?1:e===n?0:-1}function de(e,n){const{preRelease:i}=e,{preRelease:r}=n;if(i===void 0&&r)return 1;if(i&&r===void 0)return-1;if(i===void 0&&r===void 0)return 0;for(let t=0,$=i.length;t<=$;t++){const o=i[t],u=r[t];if(o!==u)return o===void 0&&u===void 0?0:o?u?v(o,u):-1:1}return 0}function j(e,n){return v(e.major,n.major)||v(e.minor,n.minor)||v(e.patch,n.patch)||de(e,n)}function O(e,n){return e.version===n.version}function _e(e,n){switch(e.operator){case"":case"=":return O(e,n);case">":return j(e,n)<0;case">=":return O(e,n)||j(e,n)<0;case"<":return j(e,n)>0;case"<=":return O(e,n)||j(e,n)>0;case void 0:return!0;default:return!1}}function he(e){return k(se,fe,le,me)(e)}function ve(e){return k(oe,ae,ue,ce)(e.trim()).split(/\s+/).join(" ")}function je(e,n){if(!e)return!1;const i=ve(n).split(" ").map(s=>he(s)).join(" ").split(/\s+/).map(s=>pe(s)),r=P(e);if(!r)return!1;const[,t,,$,o,u,a]=r,f={operator:t,version:C($,o,u,a),major:$,minor:o,patch:u,preRelease:a==null?void 0:a.split(".")};for(const s of i){const _=P(s);if(!_)return!1;const[,g,,I,M,X,b]=_,we={operator:g,version:C(I,M,X,b),major:I,minor:M,patch:X,preRelease:b==null?void 0:b.split(".")};if(!_e(we,f))return!1}return!0}const w={react:{get:()=>()=>d(new URL("__federation_shared_react-e93ad879.js",import.meta.url).href),import:!0},"react-dom":{get:()=>()=>d(new URL("__federation_shared_react-dom-b49417f4.js",import.meta.url).href),import:!0},"@emotion/react":{get:()=>()=>d(new URL("__federation_shared_@emotion/react-9ce1628c.js",import.meta.url).href),import:!0},"react-router-dom":{get:()=>()=>d(new URL("__federation_shared_react-router-dom-770100b8.js",import.meta.url).href),import:!0},"fivem-nui-react-lib":{get:()=>()=>d(new URL("__federation_shared_fivem-nui-react-lib-060d8b6b.js",import.meta.url).href),import:!0}},U=Object.create(null);B=async function(e,n="default"){return U[e]?new Promise(i=>i(U[e])):await x(e,n)||q(e)};async function d(e){return ge(()=>import(e).then(async n=>(await n.__tla,n)),[],import.meta.url)}x=async function(e,n){var r,t,$;let i=null;if((t=(r=globalThis==null?void 0:globalThis.__federation_shared__)==null?void 0:r[n])!=null&&t[e]){const o=globalThis.__federation_shared__[n][e],u=Object.keys(o)[0],a=Object.values(o)[0];($=w[e])!=null&&$.requiredVersion?je(u,w[e].requiredVersion)?i=await(await a.get())():console.log(`provider support ${e}(${u}) is not satisfied requiredVersion(\${moduleMap[name].requiredVersion})`):i=await(await a.get())()}if(i)return D(i,e)},q=async function(e){var n;if((n=w[e])!=null&&n.import){let i=await(await w[e].get())();return D(i,e)}else console.error("consumer config import=false,so cant use callback shared module")};function D(e,n){return e.default&&(e=Object.assign({},e.default,e)),U[n]=e,e}})();export{be as __tla,B as importShared,q as importSharedLocal,x as importSharedRuntime};
