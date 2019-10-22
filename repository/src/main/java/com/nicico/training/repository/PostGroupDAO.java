/*
ghazanfari_f, 8/29/2019, 10:43 AM
*/
package com.nicico.training.repository;

import com.nicico.training.model.PostGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PostGroupDAO extends JpaRepository<PostGroup, Long>, JpaSpecificationExecutor<PostGroup> {
}
