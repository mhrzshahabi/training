package com.nicico.training.iservice;/* com.nicico.training.iservice
@Author:jafari-h
@Date:5/28/2019
@Time:11:57 AM
*/


import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.dto.EquipmentDTO;

import java.util.List;

public interface IEquipmentService {

    EquipmentDTO.Info get(Long id);

    List<EquipmentDTO.Info> list();

    EquipmentDTO.Info create(EquipmentDTO.Create request);

    EquipmentDTO.Info update(Long id, EquipmentDTO.Update request);

    void delete(Long id);

    void delete(EquipmentDTO.Delete request);

    SearchDTO.SearchRs<EquipmentDTO.Info> search(SearchDTO.SearchRq request);
}
