package org.ssafy.load.application;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.ssafy.load.common.dto.ErrorCode;
import org.ssafy.load.common.exception.CommonException;
import org.ssafy.load.dao.AreaRepository;
import org.ssafy.load.dao.BuildingRepository;
import org.ssafy.load.dao.PathTimeRepository;
import org.ssafy.load.domain.AreaEntity;
import org.ssafy.load.domain.BuildingEntity;
import org.ssafy.load.domain.PathTimeEntity;
import org.ssafy.load.dto.request.BuildingRegistRequest;
import org.ssafy.load.util.PathTimeCal;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BuildingService {
    private final AreaRepository areaRepository;
    private final BuildingRepository buildingRepository;
    private final PathTimeRepository pathTimeRepository;
    private final PathTimeCal pathTimeCal;

    @Transactional
    public void registBuilding(BuildingRegistRequest buildingRegistRequest) {
        System.out.println(buildingRegistRequest.areaId());
        Optional<AreaEntity> areaEntityOptional = areaRepository.findById(buildingRegistRequest.areaId());
        AreaEntity areaEntity = areaEntityOptional.orElseThrow(() -> new CommonException(ErrorCode.INVALID_PK));

        List<BuildingEntity> buildingEntityList = buildingRepository.findByArea(areaEntity);
        BuildingEntity srcBuilding = buildingRepository.save(BuildingEntity.createNewEntity(buildingRegistRequest, areaEntity));

        String sourceAddress = new StringBuilder()
                .append(srcBuilding.getSidoName())
                .append(" ")
                .append(srcBuilding.getGugunName())
                .append(" ")
                .append(srcBuilding.getDongName())
                .append(" ")
                .append(srcBuilding.getZibunMain())
                .append("-")
                .append(srcBuilding.getZibunSub()).toString();

        for(BuildingEntity desBuilding : buildingEntityList) {
            String desAddress = new StringBuilder()
                    .append(desBuilding.getSidoName())
                    .append(" ")
                    .append(desBuilding.getGugunName())
                    .append(" ")
                    .append(desBuilding.getDongName())
                    .append(" ")
                    .append(desBuilding.getZibunMain())
                    .append("-")
                    .append(desBuilding.getZibunSub()).toString();

            Long duration = pathTimeCal.getPathTime(sourceAddress, desAddress);
            pathTimeRepository.save(PathTimeEntity.createNewEntity(srcBuilding, desBuilding, duration));
        }
    }
}
