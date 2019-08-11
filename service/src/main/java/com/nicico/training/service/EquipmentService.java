package com.nicico.training.service;/* com.nicico.training.service
@Author:jafari-h
@Date:5/28/2019
@Time:12:07 PM
*/


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EquipmentDTO;
import com.nicico.training.iservice.IEquipmentService;
import com.nicico.training.model.Equipment;
import com.nicico.training.repository.EquipmentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EquipmentService implements IEquipmentService  {

    private final ModelMapper modelMapper;
    private final EquipmentDAO equipmentDAO;

    @Transactional(readOnly = true)
    @Override
    public EquipmentDTO.Info get(Long id) {
        final Optional<Equipment> eById = equipmentDAO.findById(id);
        final Equipment equipment = eById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EquipmentNotFound));

        return modelMapper.map(equipment, EquipmentDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<EquipmentDTO.Info> list() {
        final List<Equipment> eAll = equipmentDAO.findAll();

        return modelMapper.map(eAll, new TypeToken<List<EquipmentDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public EquipmentDTO.Info create(EquipmentDTO.Create request) {
        final Equipment equipment = modelMapper.map(request, Equipment.class);
        return save(equipment);
    }

    @Transactional
    @Override
    public EquipmentDTO.Info update(Long id, EquipmentDTO.Update request) {
        final Optional<Equipment> cById = equipmentDAO.findById(id);
        final Equipment equipment = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EquipmentNotFound));
        Equipment updating = new Equipment();
        modelMapper.map(equipment, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        equipmentDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(EquipmentDTO.Delete request) {
        final List<Equipment> eAllById = equipmentDAO.findAllById(request.getIds());
        equipmentDAO.deleteAll(eAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EquipmentDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(equipmentDAO, request, equipment -> modelMapper.map(equipment, EquipmentDTO.Info.class));
    }

    // ------------------------------

    private EquipmentDTO.Info save(Equipment equipment) {
        final Equipment saved = equipmentDAO.saveAndFlush(equipment);
        return modelMapper.map(saved, EquipmentDTO.Info.class);
    }
}