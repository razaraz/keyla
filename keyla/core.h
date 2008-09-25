//
// ������ CORE ������������� ������� ���������� �����������
//
// ���� �� ��������� �����, ������� ���������� ������������ ��������� � ����������� �� ��������.
// � ���������, ����������� ����� ������ ��������� �� ��� �������
//

#pragma once

namespace core {

	// ������������� �� ��������� ���������
	void nextLayout();

	// ������������� �� �������� ���������
	// index - ����� ��������� � ������, ������� �������� � ������ LAYOUT_LIST
	void setLayout(unsigned int index);

	// �������, ������� ���������� ��� ��������� ��������� ���� � �������
	// activeWindow - ����� �������� ����
	// layout - ��������� � ���� ����
	void activeWindowChanged(HWND activeWindow, HKL layout);

	// �������, ������� ���������� ��� ��������� ��������� � �������� ����
	// layout - ����� ���������
	// return - true, ���� ����� �������� ��������� ���������, ����� false
	bool layoutChanged(HKL layout);

	// �������, ������� ���������� ��� ������� �������
	//
	// vk - ����������� ��� �������
	// modifiers - ������������ (����� ������ �� ������������ HotKey::Modifiers)
	//
	// return - true, ���� ������� ������������� ������������� ���������
	//          ������ � ������� ���� ����������, ����� false
	bool keyPressed(unsigned int vk, unsigned int modifiers);

	
	// �������� ������� ���������
	HKL getLayout();
}