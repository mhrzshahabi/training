package com.nicico.training.repository;

/* com.nicico.training.repository
@Author:jafari-h
@Date:5/28/2019
@Time:11:22 AM
*/

import com.nicico.training.model.Equipment;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EquipmentDAO extends JpaRepository<Equipment, Long>, JpaSpecificationExecutor<Equipment> {

    @Query(value = "select te.* from training.TBL_EQUIPMENT te  where Not EXISTS(select F_EQUIPMENT from training.TBL_INSTITUTE_EQUIPMENT tie where  tie.F_EQUIPMENT=te.ID and tie.F_INSTITUTE = ?)", nativeQuery = true)
    List<Equipment> getUnAttachedEquipmentsByInstituteId(Long instituteID, Pageable pageable);

    @Query(value = "select count(*) from training.TBL_EQUIPMENT te  where Not EXISTS(select F_EQUIPMENT from training.TBL_INSTITUTE_EQUIPMENT tie where  tie.F_EQUIPMENT=te.ID and tie.F_INSTITUTE = ?)", nativeQuery = true)
    Integer getUnAttachedEquipmentsCountByInstituteId(Long instituteID);

    @Query(value = "select te.* from training.TBL_EQUIPMENT te  where Not EXISTS(select F_EQUIPMENT_ID from training.TBL_TRAINING_PLACE_EQUIPMENT tpe where  tpe.F_EQUIPMENT_ID=te.ID and tpe.F_TRAINING_PLACE_ID = ?)", nativeQuery = true)
    List<Equipment> getUnAttachedEquipmentsByTrainingPlaceId(Long trainingPlaceID, Pageable pageable);

    @Query(value = "select count(*) from training.TBL_EQUIPMENT te  where Not EXISTS(select F_EQUIPMENT_ID from training.TBL_TRAINING_PLACE_EQUIPMENT tpe where  tpe.F_EQUIPMENT_ID=te.ID and tpe.F_TRAINING_PLACE_ID = ?)", nativeQuery = true)
    Integer getUnAttachedEquipmentsCountByTrainingPlaceId(Long trainingPlaceID);

}
