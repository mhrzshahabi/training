package com.nicico.training.repository;

import com.nicico.training.model.TrainingPost;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.List;

public interface TrainingPostDAO extends BaseDAO<TrainingPost, Long>{

    @Modifying
    @Query(value = "update TBL_TRAINING_POST set D_LAST_MODIFIED_DATE_NA = :modificationDate, C_MODIFIED_BY_NA = :userName where ID = :objectId", nativeQuery = true)
    public int updateModifications(Long objectId, Date modificationDate, String userName);

    @Query(value = "SELECT DISTINCT  p.C_AREA FROM TBL_TRAINING_POST p WHERE p.C_AREA is not null order by p.C_AREA", nativeQuery = true)
    List<String> findAllArea();
}
