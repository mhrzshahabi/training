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
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EquipmentService implements IEquipmentService {

    private final ModelMapper modelMapper;
    private final EquipmentDAO equipmentDAO;
    private final MessageSource messageSource;

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
    public EquipmentDTO.Info create(EquipmentDTO.Create request, HttpServletResponse response) {
        final Equipment equipment = modelMapper.map(request, Equipment.class);

        if (equipmentDAO.isExsits(equipment.getCode(), equipment.getTitleFa(),0L) > 0) {
            try {
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(405, messageSource.getMessage("msg.equipment.duplicate", null, locale));
                return null;
            }
         catch (IOException e){
            throw new TrainingException(TrainingException.ErrorType.InvalidData);
        }
        }

        return save(equipment);
    }

    @Transactional
    @Override
    public EquipmentDTO.Info update(Long id, EquipmentDTO.Update request,HttpServletResponse response) {
        final Optional<Equipment> cById = equipmentDAO.findById(id);
        final Equipment equipment = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EquipmentNotFound));
        Equipment updating = new Equipment();
        modelMapper.map(equipment, updating);
        modelMapper.map(request, updating);

        if (equipmentDAO.isExsits(updating.getCode(), updating.getTitleFa(), updating.getId()) > 0) {
            try {
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(405, messageSource.getMessage("msg.equipment.duplicate", null, locale));
                return null;
            }
            catch (IOException e){
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }

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