package com.nicico.training.repository;

/* com.nicico.training.repository
@Author:jafari-h
@Date:5/28/2019
@Time:11:22 AM
*/

import com.nicico.training.model.Equipment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface EquipmentDAO extends JpaRepository<Equipment, Long>, JpaSpecificationExecutor<Equipment> {
}
