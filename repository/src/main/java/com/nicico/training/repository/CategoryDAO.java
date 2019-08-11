package com.nicico.training.repository;/* com.nicico.training.repository
@Author:jafari-h
@Date:6/2/2019
@Time:12:29 PM
*/

import com.nicico.training.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryDAO extends JpaRepository<Category, Long>, JpaSpecificationExecutor<Category> {
}
