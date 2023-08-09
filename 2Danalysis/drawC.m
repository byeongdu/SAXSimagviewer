function k = drawC(center, l)
% k = drawC(center, l)
% 원을 그리는 함수
% center와 반경 l을 지정해야함.
% return값은 원의 handle, delete(handle)로 삭제가능

k = rectangle('position', [center(1)-l, center(2)-l, 2*l, 2*l], 'curvature', [1,1])