package com.nicico.training.repository;

import com.nicico.training.model.Equipment;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EquipmentDAO extends JpaRepository<Equipment, Long>, JpaSpecificationExecutor<Equipment> {

    @Query(value = "select te.* from TBL_EQUIPMENT te  where Not EXISTS(select F_EQUIPMENT from TBL_INSTITUTE_EQUIPMENT tie where  tie.F_EQUIPMENT=te.ID and tie.F_INSTITUTE = ?)", nativeQuery = true)
    List<Equipment> getUnAttachedEquipmentsByInstituteId(Long instituteID, Pageable pageable);

    @Query(value = "select count(*) from TBL_EQUIPMENT te  where Not EXISTS(select F_EQUIPMENT from TBL_INSTITUTE_EQUIPMENT tie where  tie.F_EQUIPMENT=te.ID and tie.F_INSTITUTE = ?)", nativeQuery = true)
    Integer getUnAttachedEquipmentsCountByInstituteId(Long instituteID);

    @Query(value = "select te.* from TBL_EQUIPMENT te  where Not EXISTS(select F_EQUIPMENT_ID from TBL_TRAINING_PLACE_EQUIPMENT tpe where  tpe.F_EQUIPMENT_ID=te.ID and tpe.F_TRAINING_PLACE_ID = ?)", nativeQuery = true)
    List<Equipment> getUnAttachedEquipmentsByTrainingPlaceId(Long trainingPlaceID, Pageable pageable);

    @Query(value = "select count(*) from TBL_EQUIPMENT te  where Not EXISTS(select F_EQUIPMENT_ID from TBL_TRAINING_PLACE_EQUIPMENT tpe where  tpe.F_EQUIPMENT_ID=te.ID and tpe.F_TRAINING_PLACE_ID = ?)", nativeQuery = true)
    Integer getUnAttachedEquipmentsCountByTrainingPlaceId(Long trainingPlaceID);

    @Query(value = "select count(*) from TBL_EQUIPMENT te where (te.c_code= :code or te.c_title_fa= :titleFa) and te.id<> :id", nativeQuery = true)
    Integer isExsits(String code, String titleFa, Long id);
}
