package org.ssafy.load.dto;

import org.ssafy.load.domain.GoodsEntity;

public record Goods(
    Long id,
    int weight,
    String detailAddress,
    int order,
    double x,
    double y,
    double z
) {

    public static Goods of(Long id, int weight, String detailAddress, int order,
        double x, double y, double z) {
        return new Goods(id, weight, detailAddress, order, x, y, z);
    }

    public static Goods form(GoodsEntity entity) {
        return Goods.of(
            entity.getId(),
            entity.getWeight(),
            entity.getDetailAddress(),
            entity.getOrdering(),
            entity.getX(),
            entity.getY(),
            entity.getZ()
        );
    }
}
