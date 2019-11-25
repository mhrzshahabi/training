package com.nicico.training.repository;
/* com.nicico.training.repository
@Author:Lotfy
*/

import com.nicico.training.model.PersonnelRegistered;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PersonnelRegisteredDAO extends JpaRepository<PersonnelRegistered, Long>, JpaSpecificationExecutor<PersonnelRegistered> {
}
